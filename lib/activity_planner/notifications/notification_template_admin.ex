defmodule ActivityPlanner.Notifications.NotificationTemplateAdmin do
  def form_fields(_) do
    [
      title: nil,
      company_id: nil,
      template_content: %{type: :richtext, rows: 10}
    ]
  end

  def index(_) do
    [
      title: nil,
      company_id: nil,
      template_content: nil
    ]
  end
end
