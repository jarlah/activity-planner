defmodule ActivityPlannerWeb.ActivityParticipantLiveTest do
  use ActivityPlannerWeb.ConnCase

  alias ActivityPlanner.Repo
  alias ActivityPlanner.Accounts
  alias ActivityPlanner.Activities.Activity

  import Phoenix.LiveViewTest

  import ActivityPlanner.Factory

  setup do
    {:ok, company: insert!(:company)}
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
      insert!(:activity, company: company)
      |> Repo.preload([:activity_group, :responsible_participant], company_id: company.company_id)

    other_participant =
      insert!(:participant, phone: "987654321", email: "other@email.com", company: company)

    other_participant2 =
      insert!(:participant, phone: "98765432", email: "other2@email.com", company: company)

    activity_participant =
      insert!(:activity_participant,
        company: company,
        activity: activity,
        participant: other_participant
      )

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
      assert html =~ activity_participant.participant_id
      assert html =~ activity_participant.activity_id
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
      assert html =~ activity.id
      assert html =~ participant.id
    end
  end
end
