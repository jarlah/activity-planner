defmodule ActivityPlannerWeb.ParticipantControllerTest do
  use ActivityPlannerWeb.ConnCase

  import ActivityPlanner.SchemasFixtures

  @create_attrs %{email: "some email", name: "some name", phone: "some phone"}
  @update_attrs %{email: "some updated email", name: "some updated name", phone: "some updated phone"}
  @invalid_attrs %{email: nil, name: nil, phone: nil}

  @moduletag :skip

  describe "index" do
    test "lists all participants", %{conn: conn} do
      conn = get(conn, ~p"/participants")
      assert html_response(conn, 200) =~ "Listing Participants"
    end
  end

  describe "new participant" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/participants/new")
      assert html_response(conn, 200) =~ "New Participant"
    end
  end

  describe "create participant" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/participants", participant: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/participants/#{id}"

      conn = get(conn, ~p"/participants/#{id}")
      assert html_response(conn, 200) =~ "Participant #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/participants", participant: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Participant"
    end
  end

  describe "edit participant" do
    setup [:create_participant]

    test "renders form for editing chosen participant", %{conn: conn, participant: participant} do
      conn = get(conn, ~p"/participants/#{participant}/edit")
      assert html_response(conn, 200) =~ "Edit Participant"
    end
  end

  describe "update participant" do
    setup [:create_participant]

    test "redirects when data is valid", %{conn: conn, participant: participant} do
      conn = put(conn, ~p"/participants/#{participant}", participant: @update_attrs)
      assert redirected_to(conn) == ~p"/participants/#{participant}"

      conn = get(conn, ~p"/participants/#{participant}")
      assert html_response(conn, 200) =~ "some updated email"
    end

    test "renders errors when data is invalid", %{conn: conn, participant: participant} do
      conn = put(conn, ~p"/participants/#{participant}", participant: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Participant"
    end
  end

  describe "delete participant" do
    setup [:create_participant]

    test "deletes chosen participant", %{conn: conn, participant: participant} do
      conn = delete(conn, ~p"/participants/#{participant}")
      assert redirected_to(conn) == ~p"/participants"

      assert_error_sent 404, fn ->
        get(conn, ~p"/participants/#{participant}")
      end
    end
  end

  defp create_participant(_) do
    participant = participant_fixture()
    %{participant: participant}
  end
end
