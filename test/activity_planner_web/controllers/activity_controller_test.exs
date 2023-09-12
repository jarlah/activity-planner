defmodule ActivityPlannerWeb.ActivityControllerTest do
  use ActivityPlannerWeb.ConnCase

  import ActivityPlanner.SchemasFixtures

  @create_attrs %{end_time: ~U[2023-09-10 18:09:00Z], start_time: ~U[2023-09-10 18:09:00Z], title: "some title"}
  @update_attrs %{end_time: ~U[2023-09-11 18:09:00Z], start_time: ~U[2023-09-11 18:09:00Z], title: "some updated title"}
  @invalid_attrs %{end_time: nil, start_time: nil, title: nil}

  @moduletag :skip

  describe "index" do
    test "lists all activities", %{conn: conn} do
      conn = get(conn, ~p"/activities")
      assert html_response(conn, 200) =~ "Listing Activities"
    end
  end

  describe "new activity" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/activities/new")
      assert html_response(conn, 200) =~ "New Activity"
    end
  end

  describe "create activity" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/activities", activity: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/activities/#{id}"

      conn = get(conn, ~p"/activities/#{id}")
      assert html_response(conn, 200) =~ "Activity #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/activities", activity: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Activity"
    end
  end

  describe "edit activity" do
    setup [:create_activity]

    test "renders form for editing chosen activity", %{conn: conn, activity: activity} do
      conn = get(conn, ~p"/activities/#{activity}/edit")
      assert html_response(conn, 200) =~ "Edit Activity"
    end
  end

  describe "update activity" do
    setup [:create_activity]

    test "redirects when data is valid", %{conn: conn, activity: activity} do
      conn = put(conn, ~p"/activities/#{activity}", activity: @update_attrs)
      assert redirected_to(conn) == ~p"/activities/#{activity}"

      conn = get(conn, ~p"/activities/#{activity}")
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, activity: activity} do
      conn = put(conn, ~p"/activities/#{activity}", activity: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Activity"
    end
  end

  describe "delete activity" do
    setup [:create_activity]

    test "deletes chosen activity", %{conn: conn, activity: activity} do
      conn = delete(conn, ~p"/activities/#{activity}")
      assert redirected_to(conn) == ~p"/activities"

      assert_error_sent 404, fn ->
        get(conn, ~p"/activities/#{activity}")
      end
    end
  end

  defp create_activity(_) do
    activity = activity_fixture()
    %{activity: activity}
  end
end
