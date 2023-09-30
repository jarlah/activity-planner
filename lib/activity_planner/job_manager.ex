defmodule ActivityPlanner.JobManager do
  use GenServer

  # Client API

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: {:global, :job_manager})
  end

  def add_job(job) do
    case GenServer.call({:global, :job_manager}, {:add, job}) do
      :ok -> {:ok, job}
      {:error, reason} -> {:error, reason}
      _ -> {:error, :unknown}
    end
  end

  def delete_job(job) do
    case GenServer.call({:global, :job_manager}, {:delete, job}) do
      :ok -> {:ok, job}
      {:error, reason} -> {:error, reason}
      _ -> {:error, :unknown}
    end
  end

  # Server Callbacks

  def init(:ok) do
    send(self(), :load_schedules)
    {:ok, nil}
  end

  def handle_info(:load_schedules, state) do
    IO.puts("Loading notification schedules from database")
    jobs = ActivityPlanner.Notifications.list_notification_schedules(skip_company_id: true)
    IO.puts("Found " <> (length(jobs) |> Integer.to_string()) <> " notification schedules")
    Enum.each(jobs, &add_job_to_quantum/1)
    {:noreply, state}
  end

  def handle_call({:add, job}, _from, state) do
    case add_job_to_quantum(job) do
      {:ok, _} -> {:reply, :ok, state}
      {:error, reason} -> {:reply, {:error, reason}, state}
    end
  end

  def handle_call({:delete, job_name}, _from, state) do
    case delete_job_from_quantum(job_name) do
      :ok -> {:reply, :ok, state}
      {:error, reason} -> {:reply, {:error, reason}, state}
    end
  end

  defp add_job_to_quantum(%ActivityPlanner.Notifications.NotificationSchedule{} = schedule) do
    try do
      # Your existing logic here
      ActivityPlanner.Scheduler.new_job(run_strategy: Quantum.RunStrategy.Local)
      |> Quantum.Job.set_overlap(false)
      |> Quantum.Job.set_name(job_name(schedule))
      |> Quantum.Job.set_schedule(schedule.cron_expression)
      |> Quantum.Job.set_task(
        {ActivityPlanner.Notifications, :send_notifications_for_schedule, [schedule.id]}
      )
      |> ActivityPlanner.Scheduler.add_job()

      {:ok, "Quantum job added successfully"}
    rescue
      exception ->
        {:error, Exception.message(exception)}
    end
  end

  defp delete_job_from_quantum(schedule) do
    try do
      ActivityPlanner.Scheduler.delete_job(job_name(schedule))
      :ok
    rescue
      exception ->
        {:error, Exception.message(exception)}
    end
  end

  defp job_name(schedule) do
    String.to_atom(schedule.name <> "_" <> schedule.activity_group_id)
  end
end
