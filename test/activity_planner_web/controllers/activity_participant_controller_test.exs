defmodule ActivityPlannerWeb.ActivityParticipantControllerTest do
  use ActivityPlannerWeb.ConnCase

  import ActivityPlanner.SchemasFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  @moduletag :skip

  describe "index" do
    test "lists all activity_participants", %{conn: conn} do
      conn = get(conn, ~p"/activity_participants")
      assert html_response(conn, 200) =~ "Listing Activity participants"
    end
  end

  describe "new activity_participant" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/activity_participants/new")
      assert html_response(conn, 200) =~ "New Activity participant"
    end
  end

  describe "create activity_participant" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/activity_participants", activity_participant: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/activity_participants/#{id}"

      conn = get(conn, ~p"/activity_participants/#{id}")
      assert html_response(conn, 200) =~ "Activity participant #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/activity_participants", activity_participant: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Activity participant"
    end
  end

  describe "edit activity_participant" do
    setup [:create_activity_participant]

    test "renders form for editing chosen activity_participant", %{conn: conn, activity_participant: activity_participant} do
      conn = get(conn, ~p"/activity_participants/#{activity_participant}/edit")
      assert html_response(conn, 200) =~ "Edit Activity participant"
    end
  end

  describe "update activity_participant" do
    setup [:create_activity_participant]

    test "redirects when data is valid", %{conn: conn, activity_participant: activity_participant} do
      conn = put(conn, ~p"/activity_participants/#{activity_participant}", activity_participant: @update_attrs)
      assert redirected_to(conn) == ~p"/activity_participants/#{activity_participant}"

      conn = get(conn, ~p"/activity_participants/#{activity_participant}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, activity_participant: activity_participant} do
      conn = put(conn, ~p"/activity_participants/#{activity_participant}", activity_participant: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Activity participant"
    end
  end

  describe "delete activity_participant" do
    setup [:create_activity_participant]

    test "deletes chosen activity_participant", %{conn: conn, activity_participant: activity_participant} do
      conn = delete(conn, ~p"/activity_participants/#{activity_participant}")
      assert redirected_to(conn) == ~p"/activity_participants"

      assert_error_sent 404, fn ->
        get(conn, ~p"/activity_participants/#{activity_participant}")
      end
    end
  end

  defp create_activity_participant(_) do
    activity_participant = activity_participant_fixture()
    %{activity_participant: activity_participant}
  end
end
