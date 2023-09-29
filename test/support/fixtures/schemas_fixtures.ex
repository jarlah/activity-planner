defmodule ActivityPlanner.SchemasFixtures do
  import ActivityPlanner.CompanyFixtures
  import ActivityPlanner.ActivityGroupFixtures
  import ActivityPlanner.ParticipantFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `ActivityPlanner.Schemas` context.
  """

  @doc """
  Generate a activity.
  """
  def activity_fixture(attrs \\ %{}, current_time \\ Timex.now()) do
    company_id = attrs |> Map.get_lazy(:company_id, fn -> company_fixture().company_id end)

    responsible_participant_id =
      attrs
      |> Map.get_lazy(:responsible_participant_id, fn ->
        participant_fixture(%{company_id: company_id}).id
      end)

    activity_group_id =
      attrs
      |> Map.get_lazy(:activity_group_id, fn ->
        activity_group_fixture(%{company_id: company_id}).id
      end)

    {:ok, activity} =
      attrs
      |> Enum.into(%{
        title: "some title",
        start_time: current_time,
        end_time: Timex.shift(current_time, days: 1),
        responsible_participant_id: responsible_participant_id,
        activity_group_id: activity_group_id,
        company_id: company_id
      })
      |> ActivityPlanner.Activities.create_activity()

    activity
  end

  @doc """
  Generate a activity_participant.
  """
  def activity_participant_fixture(attrs \\ %{}) do
    company_id = Map.get_lazy(attrs, :company_id, fn -> company_fixture().company_id end)
    participant = participant_fixture(%{company_id: company_id})
    activity = activity_fixture(%{company_id: company_id})

    {:ok, activity_participant} =
      attrs
      |> Enum.into(%{
        participant_id: participant.id,
        activity_id: activity.id,
        company_id: company_id
      })
      |> ActivityPlanner.Activities.create_activity_participant()

    activity_participant
  end
end
