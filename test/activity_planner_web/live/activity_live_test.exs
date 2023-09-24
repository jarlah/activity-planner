defmodule ActivityPlannerWeb.ActivityLiveTest do
  use ActivityPlannerWeb.ConnCase

  alias ActivityPlanner.Accounts.User
  alias ActivityPlanner.Accounts

  import Phoenix.LiveViewTest
  import ActivityPlanner.ActivitiesFixtures
  import ActivityPlanner.ActivityGroupFixtures
  import ActivityPlanner.CompanyFixtures
  import ActivityPlanner.SchemasFixtures
  import ActivityPlanner.AccountsFixtures

  @create_attrs %{description: "some description", start_time: "2023-09-19T06:31:00Z", end_time: "2023-09-19T06:31:00Z"}
  @update_attrs %{description: "some updated description", start_time: "2023-09-20T06:31:00Z", end_time: "2023-09-20T06:31:00Z"}
  @invalid_attrs %{description: nil, start_time: nil, end_time: nil}

  setup do
    {:ok, company: company_fixture()}
  end

  setup %{company: company} do
    {:ok, user} = %{email: "test@example.com", password: "passwordpassword", company_id: company.company_id} |> Accounts.register_user()
    user = user |> ActivityPlanner.Repo.preload([:companies], skip_company_id: true)
    {:ok, _} = %{user_id: user.id, company_id: user.company_id, role: "admin"} |> Accounts.create_user_role()
    {:ok, conn: log_in_user(build_conn(), user), user: user}
  end

  defp create_activity(%{company: company}) do
    activity_group = activity_group_fixture(%{ company_id: company.company_id })
    responsible_participant = participant_fixture(%{ company_id: company.company_id })
    activity = activity_fixture(%{ responsible_participant_id: responsible_participant.id, activity_group_id: activity_group.id, company_id: company.company_id })
    %{activity: activity, activity_group: activity_group, responsible_participant: responsible_participant}
  end

  describe "Index" do
    setup [:create_activity]

    test "lists all activities", %{conn: conn, activity: activity} do
      {:ok, _index_live, html} = live(conn, ~p"/activities")

      assert html =~ "Listing activities"
      assert html =~ activity.description
    end

    test "saves new activity", %{conn: conn, activity_group: activity_group, responsible_participant: responsible_participant} do
      {:ok, index_live, _html} = live(conn, ~p"/activities")

      assert index_live |> element("a", "New activity") |> render_click() =~
               "New activity"

      assert_patch(index_live, ~p"/activities/new")

      assert index_live
             |> form("#activity-form", activity: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      attrs = @create_attrs
        |> Map.put(:activity_group_id, activity_group.id)
        |> Map.put(:responsible_participant_id, responsible_participant.id)

      assert index_live
             |> form("#activity-form", activity: attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/activities")

      html = render(index_live)
      assert html =~ "Activity created successfully"
      assert html =~ "some description"
    end

    test "updates activity in listing", %{conn: conn, activity: activity} do
      {:ok, index_live, _html} = live(conn, ~p"/activities")

      assert index_live |> element("#activities-#{activity.id} a", "Edit") |> render_click() =~
               "Edit activity"

      assert_patch(index_live, ~p"/activities/#{activity}/edit")

      assert index_live
             |> form("#activity-form", activity: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#activity-form", activity: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/activities")

      html = render(index_live)
      assert html =~ "Activity updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes activity in listing", %{conn: conn, activity: activity} do
      {:ok, index_live, _html} = live(conn, ~p"/activities")

      assert index_live |> element("#activities-#{activity.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#activities-#{activity.id}")
    end
  end

  describe "Show" do
    setup [:create_activity]

    test "displays activity", %{conn: conn, activity: activity} do
      {:ok, _show_live, html} = live(conn, ~p"/activities/#{activity}")

      assert html =~ "Show activity"
      assert html =~ activity.description
    end

    test "updates activity within modal", %{conn: conn, activity: activity} do
      {:ok, show_live, _html} = live(conn, ~p"/activities/#{activity}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit activity"

      assert_patch(show_live, ~p"/activities/#{activity}/show/edit")

      assert show_live
             |> form("#activity-form", activity: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#activity-form", activity: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/activities/#{activity}")

      html = render(show_live)
      assert html =~ "Activity updated successfully"
      assert html =~ "some updated description"
    end
  end
end
