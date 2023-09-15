defmodule ActivityPlanner.JobManager do
  use GenServer

  # Client API

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: {:global, :job_manager})
  end

  def add_job(job) do
    :ok = GenServer.call({:global, :job_manager}, {:add, job})
    {:ok, job}
  end

  def delete_job(job) do
    :ok = GenServer.call({:global, :job_manager}, {:delete, job})
    {:ok, job}
  end

  # Server Callbacks

  def init(:ok) do
    IO.puts("Loading notification schedules from database")
    jobs = ActivityPlanner.Notifications.list_notification_schedules()
    IO.puts("Found " <> (length(jobs) |> Integer.to_string()) <> " notification schedules")
    Enum.each(jobs, &add_job_to_quantum/1)
    {:ok, %{}}
  end

  def handle_call({:add, job}, _from, state) do
    add_job_to_quantum(job)
    {:reply, :ok, state}
  end

  def handle_call({:delete, job_name}, _from, state) do
    delete_job_from_quantum(job_name)
    {:reply, :ok, state}
  end

  defp add_job_to_quantum(%ActivityPlanner.Notifications.NotificationSchedule{} = schedule) do
    IO.puts("Processing notification schedule #{schedule.id}")
    ActivityPlanner.Scheduler.new_job(run_strategy: Quantum.RunStrategy.Local)
    |> Quantum.Job.set_overlap(false)
    |> Quantum.Job.set_name(job_name(schedule))
    |> Quantum.Job.set_schedule(schedule.cron_expression)
    |> Quantum.Job.set_task({ActivityPlanner.Notifications, :send_notifications_for_schedule, [schedule.id]})
    |> ActivityPlanner.Scheduler.add_job()
    {:ok, "Quantum job added successfully"}
  end

  defp delete_job_from_quantum(schedule) do
    ActivityPlanner.Scheduler.delete_job(job_name(schedule))
  end

  defp job_name(schedule) do
    String.to_atom(schedule.name <> "_" <> Integer.to_string(schedule.activity_group_id))
  end
end
