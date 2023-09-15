defmodule ActivityPlanner.NotificationSchedules do
  import Ecto.Query

  def get_notification_schedules(schedule_id, current_time \\ Timex.now()) do
    [days_window_offset, days_window_length] = get_days_offset(schedule_id)
    minTime = Timex.shift(current_time, days: days_window_offset)
    maxTime = Timex.shift(current_time, days: days_window_length)
    query = from schedule in ActivityPlanner.Notifications.NotificationSchedule,
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
    ActivityPlanner.Repo.one(query)
  end

  defp get_days_offset(schedule_id) do
    query = from s in ActivityPlanner.Notifications.NotificationSchedule,
          where: s.id == ^schedule_id,
          select: [s.days_window_offset, s.days_window_length]
    ActivityPlanner.Repo.one!(query)
  end
end
