defmodule ActivityPlanner.JobsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ActivityPlanner.Jobs` context.
  """

  @doc """
  Generate a job.
  """
  def job_fixture(attrs \\ %{}) do
    {:ok, job} =
      attrs
      |> Enum.into(%{
        cron_expression: "some cron_expression",
        name: "some name",
        task_args: ["option1", "option2"],
        task_function: "some task_function",
        task_module: "some task_module"
      })
      |> ActivityPlanner.Jobs.create_job()

    job
  end
end
