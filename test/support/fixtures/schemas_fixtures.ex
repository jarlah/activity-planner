defmodule ActivityPlanner.SchemasFixtures do
  import ActivityPlanner.CompanyFixtures
  import ActivityPlanner.ActivityGroupFixtures

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
        email: Integer.to_string(:rand.uniform(89999999) + 10000000) <> "@" <> Integer.to_string(:rand.uniform(89999999) + 10000000),
        name: "some name",
        phone: Integer.to_string(:rand.uniform(89999999) + 10000000)
      })
      |> ActivityPlanner.Participants.create_participant()

    participant
  end

  @doc """
  Generate a activity.
  """
  def activity_fixture_deprecated(attrs \\ %{}, current_time \\ Timex.now()) do
    responsible_participant = participant_fixture()
    company = company_fixture()
    activity_group = activity_group_fixture(%{ company_id: company.company_id })
    {:ok, activity} =
      attrs
      |> Enum.into(%{
        title: "some title",
        start_time: current_time,
        end_time: Timex.shift(current_time, days: 1),
        responsible_participant_id: responsible_participant.id,
        activity_group_id: activity_group.id
      })
      |> ActivityPlanner.Activities.create_activity()

    activity
  end

  @doc """
  Generate a activity_participant.
  """
  def activity_participant_fixture(attrs \\ %{}) do
    participant = participant_fixture()
    activity = activity_fixture_deprecated()

    {:ok, activity_participant} =
      attrs
      |> Enum.into(%{
        participant_id: participant.id,
        activity_id: activity.id
      })
      |> ActivityPlanner.Activities.create_activity_participant()

    activity_participant
  end
end
