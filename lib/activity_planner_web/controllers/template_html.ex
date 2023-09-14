defmodule ActivityPlannerWeb.TemplateHTML do
  use ActivityPlannerWeb, :html

  embed_templates "template_html/*"

  @doc """
  Renders a template form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def template_form(assigns)
end
