defmodule ActivityPlanner.JobsTest do
  use ActivityPlanner.DataCase

  alias ActivityPlanner.Jobs

  describe "job" do
    alias ActivityPlanner.Jobs.Job

    import ActivityPlanner.JobsFixtures

    @invalid_attrs %{cron_expression: nil, name: nil, task_args: nil, task_function: nil, task_module: nil}

    test "list_job/0 returns all job" do
      job = job_fixture()
      assert Jobs.list_job() == [job]
    end

    test "get_job!/1 returns the job with given id" do
      job = job_fixture()
      assert Jobs.get_job!(job.id) == job
    end

    test "create_job/1 with valid data creates a job" do
      valid_attrs = %{cron_expression: "some cron_expression", name: "some name", task_args: ["option1", "option2"], task_function: "some task_function", task_module: "some task_module"}

      assert {:ok, %Job{} = job} = Jobs.create_job(valid_attrs)
      assert job.cron_expression == "some cron_expression"
      assert job.name == "some name"
      assert job.task_args == ["option1", "option2"]
      assert job.task_function == "some task_function"
      assert job.task_module == "some task_module"
    end

    test "create_job/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Jobs.create_job(@invalid_attrs)
    end

    test "update_job/2 with valid data updates the job" do
      job = job_fixture()
      update_attrs = %{cron_expression: "some updated cron_expression", name: "some updated name", task_args: ["option1"], task_function: "some updated task_function", task_module: "some updated task_module"}

      assert {:ok, %Job{} = job} = Jobs.update_job(job, update_attrs)
      assert job.cron_expression == "some updated cron_expression"
      assert job.name == "some updated name"
      assert job.task_args == ["option1"]
      assert job.task_function == "some updated task_function"
      assert job.task_module == "some updated task_module"
    end

    test "update_job/2 with invalid data returns error changeset" do
      job = job_fixture()
      assert {:error, %Ecto.Changeset{}} = Jobs.update_job(job, @invalid_attrs)
      assert job == Jobs.get_job!(job.id)
    end

    test "delete_job/1 deletes the job" do
      job = job_fixture()
      assert {:ok, %Job{}} = Jobs.delete_job(job)
      assert_raise Ecto.NoResultsError, fn -> Jobs.get_job!(job.id) end
    end

    test "change_job/1 returns a job changeset" do
      job = job_fixture()
      assert %Ecto.Changeset{} = Jobs.change_job(job)
    end
  end
end
