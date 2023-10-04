defmodule ActivityPlanner.JobHelper do
  alias ActivityPlanner.Notifications.NotificationSchedule

  @spec add_quantum_job(%NotificationSchedule{}) :: :ok
  def add_quantum_job(%NotificationSchedule{} = schedule) do
    ActivityPlanner.Scheduler.new_job(run_strategy: Quantum.RunStrategy.Local)
    |> Quantum.Job.set_overlap(false)
    |> Quantum.Job.set_name(job_name(schedule))
    |> Quantum.Job.set_schedule(schedule.cron_expression)
    |> Quantum.Job.set_task(
      {ActivityPlanner.Notifications, :send_notifications_for_schedule, [schedule.id]}
    )
    |> ActivityPlanner.Scheduler.add_job()
  end

  @spec delete_quantum_job(%NotificationSchedule{}) :: :ok
  def delete_quantum_job(%NotificationSchedule{} = schedule) do
    ActivityPlanner.Scheduler.delete_job(job_name(schedule))
  end

  @spec job_name(%NotificationSchedule{}) :: atom
  defp job_name(%NotificationSchedule{} = schedule) do
    schedule.id |> String.to_atom()
  end
end
