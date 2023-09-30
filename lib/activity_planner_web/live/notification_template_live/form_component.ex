defmodule ActivityPlannerWeb.NotificationTemplateLive.FormComponent do
  use ActivityPlannerWeb.FormComponent,
    key: :notification_template,
    context: ActivityPlanner.Notifications

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage notification template records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="notification-template-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:template_content]} type="textarea" rows={10} label="Content" />
        <:actions>
          <.button phx-disable-with="Saving...">Save notification template</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
