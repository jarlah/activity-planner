defmodule ActivityPlannerWeb.NotificationTemplateLive.Index do
  alias ActivityPlanner.Notifications
  alias ActivityPlanner.Notifications.NotificationTemplate

  use ActivityPlannerWeb.LiveIndex,
    key: :notification_template,
    context: Notifications,
    schema: NotificationTemplate,
    form: ActivityPlannerWeb.NotificationTemplateLive.FormComponent
end
