defmodule ActivityPlanner.ParticipantFixtures do
  @doc """
  Generate a participant.
  """
  def participant_fixture(attrs \\ %{}, opts \\ []) do
    {:ok, participant} =
      attrs
      |> Enum.into(%{
        email: random_eight_digit_string() <> "@" <> random_eight_digit_string(),
        name: "some name",
        phone: random_eight_digit_string()
      })
      |> ActivityPlanner.Participants.create_participant(opts)

    participant
  end

  defp random_eight_digit_string(), do: Integer.to_string(:rand.uniform(89_999_999) + 10_000_000)
end
