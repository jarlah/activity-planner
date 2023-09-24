defmodule ActivityPlannerWeb.NotificationTemplateLive.Show do
  alias ActivityPlanner.Notifications

  use ActivityPlannerWeb.LiveShow,
    key: :notification_template,
    context: Notifications

  def render(assigns) do
    ~H"""
      <.header>
        Notification template <%= @notification_template.id %>
        <:subtitle>This is a notification template record from your database.</:subtitle>
        <:actions>
          <.link patch={~p"/notification_templates/#{@notification_template}/show/edit"} phx-click={JS.push_focus()}>
            <.button>Edit notification template</.button>
          </.link>
        </:actions>
      </.header>

      <.list>
        <:item title="Title"><%= @notification_template.title %></:item>
        <:item title="Content"><%= @notification_template.template_content %></:item>
      </.list>

      <.back navigate={~p"/notification_templates"}>Back to notification templates</.back>

      <.modal :if={@live_action == :edit} id="notification_template-modal" show on_cancel={JS.patch(~p"/notification_templates/#{@notification_template}")}>
        <.live_component
          module={ActivityPlannerWeb.NotificationTemplateLive.FormComponent}
          id={@notification_template.id}
          title={@page_title}
          action={@live_action}
          notification_template={@notification_template}
          patch={~p"/notification_templates/#{@notification_template}"}
        />
      </.modal>
    """
  end
end
