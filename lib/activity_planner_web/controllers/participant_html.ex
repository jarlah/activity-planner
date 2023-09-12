defmodule ActivityPlannerWeb.ParticipantHTML do
  use ActivityPlannerWeb, :html

  embed_templates "participant_html/*"

  @doc """
  Renders a participant form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def participant_form(assigns)
end
