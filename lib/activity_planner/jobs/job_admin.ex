defmodule ActivityPlanner.Jobs.JobAdmin do
  def after_insert(_conn, job) do
    ActivityPlanner.JobManager.add_job(job)
  end

  def after_delete(_conn, job) do
    ActivityPlanner.JobManager.delete_job(job.name)
  end
end
