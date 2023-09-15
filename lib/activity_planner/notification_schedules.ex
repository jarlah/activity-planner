defmodule ActivityPlanner.NotificationSchedules do
  import Ecto.Query

  def get_notification_schedules(schedule_id, current_time \\ Timex.now()) do
    days_offset = get_days_offset(schedule_id)
    minTime = current_time
    maxTime = Timex.shift(current_time, days: days_offset)
    query = from schedule in ActivityPlanner.Notifications.NotificationSchedule,
      join: activity_groups in assoc(schedule, :activity_group),
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
          activities: {
            activities,
            activity_group: activity_groups,
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
          select: s.days_offset
    ActivityPlanner.Repo.one!(query)
  end
end
