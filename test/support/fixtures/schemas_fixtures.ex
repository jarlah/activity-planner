defmodule ActivityPlanner.SchemasFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ActivityPlanner.Schemas` context.
  """

  @doc """
  Generate a participant.
  """
  def participant_fixture(attrs \\ %{}) do
    {:ok, participant} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name",
        phone: "some phone"
      })
      |> ActivityPlanner.Schemas.create_participant()

    participant
  end

  @doc """
  Generate a activity.
  """
  def activity_fixture(attrs \\ %{}, current_time \\ Timex.now()) do
    responsible_participant = participant_fixture()

    {:ok, activity} =
      attrs
      |> Enum.into(%{
        title: "some title",
        start_time: current_time,
        end_time: Timex.shift(current_time, days: 1),
        responsible_participant_id: responsible_participant.id
      })
      |> ActivityPlanner.Schemas.create_activity()

    activity
  end

  @doc """
  Generate a activity_participant.
  """
  def activity_participant_fixture(attrs \\ %{}) do
    participant = participant_fixture()
    activity = activity_fixture()

    {:ok, activity_participant} =
      attrs
      |> Enum.into(%{
        participant_id: participant.id,
        activity_id: activity.id
      })
      |> ActivityPlanner.Schemas.create_activity_participant()

    activity_participant
  end
end
