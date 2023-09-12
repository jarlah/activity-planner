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
  def activity_fixture(attrs \\ %{}) do
    {:ok, activity} =
      attrs
      |> Enum.into(%{
        end_time: ~U[2023-09-10 18:09:00Z],
        start_time: ~U[2023-09-10 18:09:00Z],
        title: "some title"
      })
      |> ActivityPlanner.Schemas.create_activity()

    activity
  end

  @doc """
  Generate a activity_participant.
  """
  def activity_participant_fixture(attrs \\ %{}) do
    {:ok, activity_participant} =
      attrs
      |> Enum.into(%{

      })
      |> ActivityPlanner.Schemas.create_activity_participant()

    activity_participant
  end
end
