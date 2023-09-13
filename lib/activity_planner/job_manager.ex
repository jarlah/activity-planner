defmodule ActivityPlanner.JobManager do
  use GenServer

  # Client API

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def add_job(job) do
    GenServer.call(__MODULE__, {:add, job})
  end

  def delete_job(job_name) do
    GenServer.call(__MODULE__, {:delete, job_name})
  end

  # Server Callbacks

  def init(:ok) do
    IO.puts("Loading jobs from database")
    jobs = ActivityPlanner.Jobs.list_job()
    IO.puts("Found " <> (length(jobs) |> Integer.to_string()) <> " jobs")
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

  # Helper Functions

  defp add_job_to_quantum(%ActivityPlanner.Jobs.Job{} = job) do
    case Crontab.CronExpression.Parser.parse(job.cron_expression) do
      {:ok, cron_expression} ->
        task = {Module.concat([job.task_module]), String.to_atom(job.task_function), job.task_args || []} |> IO.inspect()

        ActivityPlanner.Scheduler.new_job(run_strategy: Quantum.RunStrategy.Local)
        |> Quantum.Job.set_overlap(false)
        |> Quantum.Job.set_name(String.to_atom(job.name))
        |> Quantum.Job.set_schedule(cron_expression)
        |> Quantum.Job.set_task(task)
        |> IO.inspect()
        |> ActivityPlanner.Scheduler.add_job()

        {:ok, "Job added successfully"}

      {:error, _reason} ->
        {:error, "Invalid cron expression for job " <> job.name}
    end
  end

  defp delete_job_from_quantum(job_name) do
    ActivityPlanner.Scheduler.delete_job(String.to_atom(job_name))
  end
end
