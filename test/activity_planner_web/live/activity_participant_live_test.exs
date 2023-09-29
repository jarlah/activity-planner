defmodule ActivityPlannerWeb.ActivityParticipantLiveTest do
  use ActivityPlannerWeb.ConnCase

  alias ActivityPlanner.Repo
  alias ActivityPlanner.Accounts
  alias ActivityPlanner.Activities.Activity

  import Phoenix.LiveViewTest
  import ActivityPlanner.CompanyFixtures
  import ActivityPlanner.ActivityFixtures
  import ActivityPlanner.ParticipantFixtures

  setup do
    {:ok, company: company_fixture()}
  end

  setup %{company: company} do
    {:ok, user} =
      %{email: "test@example.com", password: "passwordpassword", company_id: company.company_id}
      |> Accounts.register_user()

    user = user |> ActivityPlanner.Repo.preload([:companies], skip_company_id: true)

    {:ok, _} =
      %{user_id: user.id, company_id: user.company_id, role: "admin"}
      |> Accounts.create_user_role()

    {:ok, conn: log_in_user(build_conn(), user), user: user}
  end

  defp create_activity_participant(%{company: company}) do
    activity =
      %Activity{} =
      activity_fixture(%{company_id: company.company_id})
      |> Repo.preload([:activity_group, :responsible_participant], company_id: company.company_id)

    other_participant = participant_fixture(%{company_id: company.company_id})
    other_participant2 = participant_fixture(%{company_id: company.company_id})

    activity_participant =
      activity_participant_fixture(%{
        company_id: company.company_id,
        activity_id: activity.id,
        participant_id: other_participant.id
      })

    %{
      activity: activity,
      activity_participant: activity_participant,
      participant: other_participant2
    }
  end

  describe "Index" do
    setup [:create_activity_participant]

    test "lists all activity participants", %{
      conn: conn,
      activity_participant: activity_participant
    } do
      {:ok, _index_live, html} = live(conn, ~p"/activity_participants")

      assert html =~ "Listing activity participants"
      assert html =~ activity_participant.participant_id |> Integer.to_string()
      assert html =~ activity_participant.activity_id |> Integer.to_string()
    end

    test "saves new activity participant", %{
      conn: conn,
      activity: activity,
      participant: participant
    } do
      {:ok, index_live, _html} = live(conn, ~p"/activity_participants")

      assert index_live |> element("a", "New activity participant") |> render_click() =~
               "New activity participant"

      assert_patch(index_live, ~p"/activity_participants/new")

      assert index_live
             |> form("#activity-participant-form", activity: %{})
             |> render_change() =~ "can&#39;t be blank"

      attrs =
        %{}
        |> Map.put(:activity_id, activity.id)
        |> Map.put(:participant_id, participant.id)

      assert index_live
             |> form("#activity-participant-form", activity_participant: attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/activity_participants")

      html = render(index_live)
      assert html =~ "Activity participant created successfully"
      assert html =~ activity.id |> Integer.to_string()
      assert html =~ participant.id |> Integer.to_string()
    end
  end
end
