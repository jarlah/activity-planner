defmodule ActivityPlanner.SchemasFixtures do
  import ActivityPlanner.CompanyFixtures
  import ActivityPlanner.ActivityGroupFixtures
  import ActivityPlanner.FixtureHelpers

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
        email: random_eight_digit_string() <> "@" <> random_eight_digit_string(),
        name: "some name",
        phone: random_eight_digit_string()
      })
      |> ActivityPlanner.Participants.create_participant()

    participant
  end

  defp random_eight_digit_string(), do: Integer.to_string(:rand.uniform(89999999) + 10000000)

  @doc """
  Generate a activity.
  """
  def activity_fixture_deprecated(attrs \\ %{}, current_time \\ Timex.now()) do
    company_id = get_with_lazy_default(attrs, :company_id, fn -> company_fixture().company_id end)
    responsible_participant = participant_fixture(%{ company_id: company_id })
    activity_group = activity_group_fixture(%{ company_id: company_id })
    {:ok, activity} =
      attrs
      |> Enum.into(%{
        title: "some title",
        start_time: current_time,
        end_time: Timex.shift(current_time, days: 1),
        responsible_participant_id: responsible_participant.id,
        activity_group_id: activity_group.id,
        company_id: company_id
      })
      |> ActivityPlanner.Activities.create_activity()

    activity
  end

  @doc """
  Generate a activity_participant.
  """
  def activity_participant_fixture(attrs \\ %{}) do
    company_id = get_with_lazy_default(attrs, :company_id, fn -> company_fixture().company_id end)
    participant = participant_fixture(%{ company_id: company_id })
    activity = activity_fixture_deprecated(%{ company_id: company_id })

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
