defmodule ActivityPlanner.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activities" do
    field :end_time, :utc_datetime
    field :start_time, :utc_datetime
    field :title, :string

    belongs_to :responsible_participant, ActivityPlanner.Participant.Participant

    many_to_many :participants, ActivityPlanner.Participant.Participant, join_through: "activity_participants"

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:title, :start_time, :end_time, :responsible_participant_id])
    |> validate_required([:title, :start_time, :end_time, :responsible_participant_id])
  end
end
