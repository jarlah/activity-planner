defmodule ActivityPlanner.Notifications do
  import Ecto.Query

  alias ActivityPlanner.JobManager
  alias ActivityPlanner.Notifications.NotificationTemplate
  alias ActivityPlanner.Mailer
  alias ActivityPlanner.SMS
  alias Timex.Format.DateTime.Formatter
  alias ActivityPlanner.Notifications.NotificationSchedule
  alias ActivityPlanner.Notifications.SentNotification
  alias ActivityPlanner.Repo

  @doc """
  Returns the list of notification schedules.

  ## Examples

      iex> schedule = insert!(:notification_schedule)
      iex> [%NotificationSchedule{}] = list_notification_schedules(company_id: schedule.company_id)
      iex> [%NotificationSchedule{}] = list_notification_schedules(skip_company_id: true)
      iex> non_existent_company_id = Ecto.UUID.generate()
      iex> list_notification_schedules(company_id: non_existent_company_id)
      []

  """
  def list_notification_schedules(opts \\ []) do
    Repo.all(NotificationSchedule, opts)
  end

  @doc """
  Returns the list of notification templates.

  ## Examples

      iex> template = insert!(:notification_template)
      iex> [%NotificationTemplate{}] = list_notification_templates(company_id: template.company_id)
      iex> [%NotificationTemplate{}] = list_notification_templates(skip_company_id: true)
      iex> non_existent_company_id = Ecto.UUID.generate()
      iex> list_notification_templates(company_id: non_existent_company_id)
      []

  """
  def list_notification_templates(opts \\ []) do
    Repo.all(NotificationTemplate, opts)
  end

  @doc """
  Gets a single notification template.

  ## Examples

      iex> template = insert!(:notification_template)
      iex> get_notification_template!(template.id, company_id: template.company_id)

  """
  def get_notification_template!(id, opts \\ []) do
    Repo.get!(NotificationTemplate, id, opts)
  end

  @doc """
  Creates a notification template.

  ## Examples

      iex> company = insert!(:company)
      iex> attrs = %{ title: "test template", template_content: "test content" }
      iex> {:ok, %NotificationTemplate{}} = create_notification_template(attrs, company_id: company.company_id)

  """
  def create_notification_template(attrs \\ %{}, opts \\ []) do
    %NotificationTemplate{}
    |> NotificationTemplate.changeset(attrs, opts)
    |> Repo.insert(opts)
  end

  @doc """
  Updates a notification template.

  ## Examples

      iex> template = insert!(:notification_template)
      iex> {:ok, _} = update_notification_template(template, %{ template_content: "Hello" })
      iex> {:error, _} = update_notification_template(template, %{ template_content: nil })

  """
  def update_notification_template(%NotificationTemplate{} = template, attrs) do
    template
    |> NotificationTemplate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a notification template.

  ## Examples

      iex> template = insert!(:notification_template)
      iex> {:ok, _} = delete_notification_template(template)

  """
  def delete_notification_template(%NotificationTemplate{} = participant) do
    Repo.delete(participant)
  end

  @doc """
  Changes a notification template.

  ## Examples

      iex> template = insert!(:notification_template)
      iex> %Ecto.Changeset{} = change_notification_template(template, %{ template_content: "Hello" })

  """
  def change_notification_template(%NotificationTemplate{} = participant, attrs \\ %{}) do
    NotificationTemplate.changeset(participant, attrs)
  end

  def send_notifications_for_schedule(schedule_id) do
    case get_notification_schedules(
           schedule_id,
           Timex.now()
         ) do
      nil ->
        IO.puts("No matching schedule with activities found")

      schedule ->
        schedule.activity_group.activities
        |> Enum.each(fn activity ->
          send_notifications(schedule.template, schedule.medium, activity)
        end)
    end
  end

  defp send_notifications(template, :email, activity) do
    from_email = Application.fetch_env!(:activity_planner, ActivityPlanner.Mailer)[:from_email]

    (activity.participants ++ [activity.responsible_participant])
    |> Enum.each(fn participant ->
      content = render_template_for_activity(template.template_content, participant, activity)
      {:ok, _} = send_email(participant.email, from_email, "Reminder for activity", content)
      {:ok, _} = sent_notification("email", participant.email, content, activity.id)
    end)
  end

  defp send_notifications(template, :sms, activity) do
    (activity.participants ++ [activity.responsible_participant])
    |> Enum.each(fn participant ->
      content = render_template_for_activity(template.template_content, participant, activity)
      {:ok, _} = SMS.send_sms(participant.phone, content)
      {:ok, _} = sent_notification("sms", participant.phone, content, activity.id)
    end)
  end

  defp send_email(recipient, sender, subject, body) do
    email =
      Swoosh.Email.new()
      |> Swoosh.Email.to(recipient)
      |> Swoosh.Email.from(sender)
      |> Swoosh.Email.subject(subject)
      |> Swoosh.Email.html_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  defp sent_notification(medium, receiver, content, activity_id) do
    %SentNotification{
      sent_at: DateTime.truncate(DateTime.utc_now(), :second),
      medium: medium,
      receiver: receiver,
      status: "sent",
      actual_content: content,
      actual_title: "Reminder for activity",
      activity_id: activity_id
    }
    |> SentNotification.changeset(%{})
    |> Repo.insert()
  end

  defp render_template_for_activity(template, participant, activity) do
    Mustache.render(template, %{
      company: activity.activity_group.company |> Map.from_struct(),
      activityGroup: activity.activity_group |> Map.from_struct(),
      startDate: Formatter.format!(activity.start_time, "%d-%m-%Y", :strftime),
      startTime: Formatter.format!(activity.start_time, "%H:%M %Z", :strftime),
      participant: participant |> Map.from_struct(),
      participants: activity.participants |> Enum.map(&Map.from_struct/1),
      responsibleParticipant: activity.responsible_participant |> Map.from_struct()
    })
  end

  def get_notification_schedules(schedule_id, current_time \\ Timex.now()) do
    [hours_window_offset, hours_window_length] = get_hours_offset(schedule_id)
    minTime = Timex.shift(current_time, hours: hours_window_offset)
    maxTime = Timex.shift(minTime, hours: hours_window_length)

    query =
      from schedule in ActivityPlanner.Notifications.NotificationSchedule,
        join: activity_groups in assoc(schedule, :activity_group),
        join: company in assoc(activity_groups, :company),
        join: activities in assoc(activity_groups, :activities),
        left_join: participants in assoc(activities, :participants),
        join: responsible_participant in assoc(activities, :responsible_participant),
        join: template in assoc(schedule, :template),
        where: schedule.id == ^schedule_id,
        where: activities.start_time >= ^minTime and activities.end_time <= ^maxTime,
        preload: [
          template: template,
          activity_group: {
            activity_groups,
            company: company,
            activities: {
              activities,
              activity_group: {activity_groups, company: company},
              participants: participants,
              responsible_participant: responsible_participant
            }
          }
        ]

    ActivityPlanner.Repo.one(query, skip_company_id: true)
  end

  defp get_hours_offset(schedule_id) do
    query =
      from s in ActivityPlanner.Notifications.NotificationSchedule,
        where: s.id == ^schedule_id,
        select: [s.hours_window_offset, s.hours_window_length]

    ActivityPlanner.Repo.one!(query, skip_company_id: true)
  end

  @doc """
  Creates a notification schedule.

  ## Examples

      iex> company = insert!(:company)
      iex> activity_group = insert!(:activity_group, company: company)
      iex> template = insert!(:notification_template, company: company)
      iex> {:ok, cron_expression} = Crontab.CronExpression.Ecto.Type.cast("* * * * *")
      iex> attrs = %{ name: "test schedule", medium: :sms, cron_expression: cron_expression, hours_window_length: 24, enabled: true, template_id: template.id, activity_group_id: activity_group.id }
      iex> {:ok, %NotificationSchedule{}} = create_notification_schedule(attrs, company_id: company.company_id)

  """
  def create_notification_schedule(attrs \\ %{}, opts \\ []) do
    multi =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(
        :notification_schedule,
        NotificationSchedule.changeset(%NotificationSchedule{}, attrs, opts),
        opts
      )
      |> Ecto.Multi.run(:job_manager, fn _repo, %{notification_schedule: notification_schedule} ->
        case JobManager.add_job(notification_schedule) do
          {:ok, _job} -> {:ok, notification_schedule}
          {:error, _reason} -> {:error, :job_manager_failed}
        end
      end)

    case Repo.transaction(multi) do
      {:ok, %{notification_schedule: notification_schedule}} ->
        {:ok, notification_schedule}

      {:error, :notification_schedule, changeset, _} ->
        {:error, changeset}

      {:error, :job_manager, reason, _} ->
        {:error, reason}
    end
  end

  @doc """
  Deletes a notification schedule.

  ## Examples

      iex> schedule = insert!(:notification_schedule)
      iex> {:ok, _} = delete_notification_schedule(schedule)

  """
  def delete_notification_schedule(%NotificationSchedule{} = schedule) do
    multi =
      Ecto.Multi.new()
      |> Ecto.Multi.delete(:notification_schedule, schedule)
      |> Ecto.Multi.run(:job_manager, fn _repo, %{notification_schedule: notification_schedule} ->
        case JobManager.delete_job(notification_schedule) do
          {:ok, _job} -> {:ok, notification_schedule}
          {:error, _reason} -> {:error, :job_manager_failed}
        end
      end)

    case Repo.transaction(multi) do
      {:ok, %{notification_schedule: notification_schedule}} ->
        {:ok, notification_schedule}

      {:error, :notification_schedule, reason, _} ->
        {:error, reason}

      {:error, :job_manager, reason, _} ->
        {:error, reason}
    end
  end

  @doc """
  Updates a notification schedule.

  ## Examples

      iex> schedule = insert!(:notification_schedule)
      iex> {:ok, _} = update_notification_schedule(schedule, %{ enabled: false })

  """
  def update_notification_schedule(%NotificationSchedule{} = schedule, attrs, opts \\ []) do
    multi =
      Ecto.Multi.new()
      |> Ecto.Multi.update(
        :updated_notification_schedule,
        fn _ ->
          NotificationSchedule.changeset(schedule, attrs, opts)
        end,
        opts
      )
      |> Ecto.Multi.run(:job_manager, fn _repo, %{updated_notification_schedule: schedule} ->
        case JobManager.add_job(schedule) do
          {:ok, _job} -> {:ok, schedule}
          {:error, _reason} -> {:error, :job_manager_failed}
        end
      end)

    case Repo.transaction(multi) do
      {:ok, %{updated_notification_schedule: notification_schedule}} ->
        {:ok, notification_schedule}

      {:error, :updated_notification_schedule, changeset, _} ->
        {:error, changeset}

      {:error, :job_manager, reason, _} ->
        {:error, reason}
    end
  end

  @doc """
  Changes a notification schedule.

  ## Examples

      iex> schedule = insert!(:notification_schedule)
      iex> %Ecto.Changeset{} = change_notification_schedule(schedule, %{ enabled: false })

  """
  def change_notification_schedule(%NotificationSchedule{} = notification_schedule, attrs \\ %{}) do
    NotificationSchedule.changeset(notification_schedule, attrs)
  end

  @doc """
  Gets a notification schedule.

  ## Examples

      iex> schedule = insert!(:notification_schedule)
      iex> %NotificationSchedule{} = get_notification_schedule!(schedule.id, company_id: schedule.company_id)
      iex> %NotificationSchedule{} = get_notification_schedule!(schedule.id, skip_company_id: true)

  """
  def get_notification_schedule!(id, opts \\ []) do
    Repo.get!(NotificationSchedule, id, opts)
  end
end
