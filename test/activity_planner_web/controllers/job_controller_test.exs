defmodule ActivityPlannerWeb.JobControllerTest do
  use ActivityPlannerWeb.ConnCase

  import ActivityPlanner.JobsFixtures

  @create_attrs %{cron_expression: "some cron_expression", name: "some name", task_args: ["option1", "option2"], task_function: "some task_function", task_module: "some task_module"}
  @update_attrs %{cron_expression: "some updated cron_expression", name: "some updated name", task_args: ["option1"], task_function: "some updated task_function", task_module: "some updated task_module"}
  @invalid_attrs %{cron_expression: nil, name: nil, task_args: nil, task_function: nil, task_module: nil}

  describe "index" do
    test "lists all job", %{conn: conn} do
      conn = get(conn, ~p"/job")
      assert html_response(conn, 200) =~ "Listing Job"
    end
  end

  describe "new job" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/job/new")
      assert html_response(conn, 200) =~ "New Job"
    end
  end

  describe "create job" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/job", job: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/job/#{id}"

      conn = get(conn, ~p"/job/#{id}")
      assert html_response(conn, 200) =~ "Job #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/job", job: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Job"
    end
  end

  describe "edit job" do
    setup [:create_job]

    test "renders form for editing chosen job", %{conn: conn, job: job} do
      conn = get(conn, ~p"/job/#{job}/edit")
      assert html_response(conn, 200) =~ "Edit Job"
    end
  end

  describe "update job" do
    setup [:create_job]

    test "redirects when data is valid", %{conn: conn, job: job} do
      conn = put(conn, ~p"/job/#{job}", job: @update_attrs)
      assert redirected_to(conn) == ~p"/job/#{job}"

      conn = get(conn, ~p"/job/#{job}")
      assert html_response(conn, 200) =~ "some updated cron_expression"
    end

    test "renders errors when data is invalid", %{conn: conn, job: job} do
      conn = put(conn, ~p"/job/#{job}", job: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Job"
    end
  end

  describe "delete job" do
    setup [:create_job]

    test "deletes chosen job", %{conn: conn, job: job} do
      conn = delete(conn, ~p"/job/#{job}")
      assert redirected_to(conn) == ~p"/job"

      assert_error_sent 404, fn ->
        get(conn, ~p"/job/#{job}")
      end
    end
  end

  defp create_job(_) do
    job = job_fixture()
    %{job: job}
  end
end
