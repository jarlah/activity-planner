defmodule ActivityPlannerWeb.PageController do
  use ActivityPlannerWeb, :controller

  def home(conn, _params) do
    conn |> redirect(to: ~p"/activities")
  end
end
