defmodule ActivityPlanner.Schemas do
  @moduledoc """
  The Schemas context.
  """

  import Ecto.Query, warn: false
  alias ActivityPlanner.Repo

  alias ActivityPlanner.Schemas.Participant

  @doc """
  Returns the list of participants.

  ## Examples

      iex> list_participants()
      [%Participant{}, ...]

  """
  def list_participants do
    Repo.all(Participant)
  end

  @doc """
  Gets a single participant.

  Raises `Ecto.NoResultsError` if the Participant does not exist.

  ## Examples

      iex> get_participant!(123)
      %Participant{}

      iex> get_participant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_participant!(id), do: Repo.get!(Participant, id)

  @doc """
  Creates a participant.

  ## Examples

      iex> create_participant(%{field: value})
      {:ok, %Participant{}}

      iex> create_participant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_participant(attrs \\ %{}) do
    %Participant{}
    |> Participant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a participant.

  ## Examples

      iex> update_participant(participant, %{field: new_value})
      {:ok, %Participant{}}

      iex> update_participant(participant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_participant(%Participant{} = participant, attrs) do
    participant
    |> Participant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a participant.

  ## Examples

      iex> delete_participant(participant)
      {:ok, %Participant{}}

      iex> delete_participant(participant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_participant(%Participant{} = participant) do
    Repo.delete(participant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking participant changes.

  ## Examples

      iex> change_participant(participant)
      %Ecto.Changeset{data: %Participant{}}

  """
  def change_participant(%Participant{} = participant, attrs \\ %{}) do
    Participant.changeset(participant, attrs)
  end

  alias ActivityPlanner.Schemas.Activity

  @doc """
  Returns the list of activities.

  ## Examples

      iex> list_activities()
      [%Activity{}, ...]

  """
  def list_activities do
    Repo.all(Activity)
  end

  @doc """
  Gets a single activity.

  Raises `Ecto.NoResultsError` if the Activity does not exist.

  ## Examples

      iex> get_activity!(123)
      %Activity{}

      iex> get_activity!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity!(id), do: Repo.get!(Activity, id)

  @doc """
  Creates a activity.

  ## Examples

      iex> create_activity(%{field: value})
      {:ok, %Activity{}}

      iex> create_activity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity(attrs \\ %{}) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a activity.

  ## Examples

      iex> update_activity(activity, %{field: new_value})
      {:ok, %Activity{}}

      iex> update_activity(activity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity(%Activity{} = activity, attrs) do
    activity
    |> Activity.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a activity.

  ## Examples

      iex> delete_activity(activity)
      {:ok, %Activity{}}

      iex> delete_activity(activity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity(%Activity{} = activity) do
    Repo.delete(activity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity changes.

  ## Examples

      iex> change_activity(activity)
      %Ecto.Changeset{data: %Activity{}}

  """
  def change_activity(%Activity{} = activity, attrs \\ %{}) do
    Activity.changeset(activity, attrs)
  end

  alias ActivityPlanner.Schemas.ActivityParticipant

  @doc """
  Returns the list of activity_participants.

  ## Examples

      iex> list_activity_participants()
      [%ActivityParticipant{}, ...]

  """
  def list_activity_participants do
    Repo.all(ActivityParticipant)
  end

  @doc """
  Gets a single activity_participant.

  Raises `Ecto.NoResultsError` if the Activity participant does not exist.

  ## Examples

      iex> get_activity_participant!(123)
      %ActivityParticipant{}

      iex> get_activity_participant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity_participant!(id), do: Repo.get!(ActivityParticipant, id)

  @doc """
  Creates a activity_participant.

  ## Examples

      iex> create_activity_participant(%{field: value})
      {:ok, %ActivityParticipant{}}

      iex> create_activity_participant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity_participant(attrs \\ %{}) do
    %ActivityParticipant{}
    |> ActivityParticipant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a activity_participant.

  ## Examples

      iex> update_activity_participant(activity_participant, %{field: new_value})
      {:ok, %ActivityParticipant{}}

      iex> update_activity_participant(activity_participant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity_participant(%ActivityParticipant{} = activity_participant, attrs) do
    activity_participant
    |> ActivityParticipant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a activity_participant.

  ## Examples

      iex> delete_activity_participant(activity_participant)
      {:ok, %ActivityParticipant{}}

      iex> delete_activity_participant(activity_participant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity_participant(%ActivityParticipant{} = activity_participant) do
    Repo.delete(activity_participant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity_participant changes.

  ## Examples

      iex> change_activity_participant(activity_participant)
      %Ecto.Changeset{data: %ActivityParticipant{}}

  """
  def change_activity_participant(%ActivityParticipant{} = activity_participant, attrs \\ %{}) do
    ActivityParticipant.changeset(activity_participant, attrs)
  end
end
