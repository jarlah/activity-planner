defmodule ActivityPlanner.Notifications.NotificationTemplateAdmin do
  def form_fields(_) do
    [
      title: nil,
      activity_group_id: nil,
      template_content: %{type: :richtext, rows: 10}
    ]
  end
end
