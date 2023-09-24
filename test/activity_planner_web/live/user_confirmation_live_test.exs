defmodule ActivityPlannerWeb.UserConfirmationLiveTest do
  use ActivityPlannerWeb.ConnCase

  import Phoenix.LiveViewTest
  import ActivityPlanner.AccountsFixtures
  import ActivityPlanner.CompanyFixtures

  alias ActivityPlanner.Accounts
  alias ActivityPlanner.Repo

  setup do
    {:ok, company: company_fixture()}
  end

  setup %{company: company} do
    %{user: user_fixture(%{ company_id: company.company_id })}
  end

  describe "Confirm user" do
    test "renders confirmation page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/users/confirm/some-token")
      assert html =~ "Confirm Account"
    end

    test "does not confirm email with invalid token", %{conn: conn, user: user} do
      {:ok, lv, _html} = live(conn, ~p"/users/confirm/invalid-token")

      {:ok, conn} =
        lv
        |> form("#confirmation_form")
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "User confirmation link is invalid or it has expired"

      refute Accounts.get_user!(user.id, skip_company_id: true).confirmed_at
    end
  end
end
