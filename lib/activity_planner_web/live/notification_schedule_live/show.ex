defmodule ActivityPlannerWeb.NotificationScheduleLive.Show do
  use ActivityPlannerWeb.LiveShow,
    key: :notification_schedule,
    context: ActivityPlanner.Notifications

  def render(assigns) do
    ~H"""
    <h1>Show</h1>
    """
  end
end
