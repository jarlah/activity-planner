defmodule ActivityPlannerWeb.NotificationTemplateLive.Index do
  alias ActivityPlanner.Notifications
  alias ActivityPlanner.Notifications.NotificationTemplate

  use ActivityPlannerWeb.LiveIndex,
    key: :notification_template,
    context: Notifications,
    schema: NotificationTemplate,
    form: ActivityPlannerWeb.NotificationTemplateLive.FormComponent

  def render(assigns) do
    ~H"""
    <.header>
      Listing notification templates
      <:actions>
        <.link patch={~p"/notification_templates/new"}>
          <.button>New notification template</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="notification_templates"
      rows={@streams.notification_templates}
      row_click={
        fn {_id, notification_template} ->
          JS.navigate(~p"/notification_templates/#{notification_template}")
        end
      }
    >
      <:col :let={{_id, notification_template}} label="Title">
        <%= notification_template.title %>
      </:col>
      <:col :let={{_id, notification_template}} label="Content">
        <%= notification_template.template_content %>
      </:col>
      <:action :let={{_id, notification_template}}>
        <div class="sr-only">
          <.link navigate={~p"/notification_templates/#{notification_template}"}>Show</.link>
        </div>
        <.link patch={~p"/notification_templates/#{notification_template}/edit"}>Edit</.link>
      </:action>
      <:action :let={{id, notification_template}}>
        <.link
          phx-click={JS.push("delete", value: %{id: notification_template.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="notification-template-modal"
      show
      on_cancel={JS.patch(~p"/notification_templates")}
    >
      <.live_component
        module={ActivityPlannerWeb.NotificationTemplateLive.FormComponent}
        id={@notification_template.id || :new}
        title={@page_title}
        action={@live_action}
        notification_template={@notification_template}
        patch={~p"/notification_templates"}
      />
    </.modal>
    """
  end
end
