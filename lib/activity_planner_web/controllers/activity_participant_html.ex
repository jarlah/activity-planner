defmodule ActivityPlannerWeb.ActivityParticipantHTML do
  use ActivityPlannerWeb, :html

  embed_templates "activity_participant_html/*"

  @doc """
  Renders a activity_participant form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def activity_participant_form(assigns)
end
