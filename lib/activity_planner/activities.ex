defmodule ActivityPlanner.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  alias ActivityPlanner.Repo

  alias ActivityPlanner.Activities.Activity
  alias ActivityPlanner.Activities.ActivityGroup
  alias ActivityPlanner.Activities.ActivityParticipant

  @doc """
  Returns the list of activities.

  ## Examples

      iex> list_activities()
      [%Activity{}, ...]

  """
  def list_activities do
    Repo.all(Activity)
  end

  def list_activity_groups do
    Repo.all(ActivityGroup)
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

  def get_activity_group!(id), do: Repo.get!(ActivityGroup, id)

  @doc """
  Creates a activity.

  ## Examples

      iex> create_activity(%{field: value})
      {:ok, %Activity{}}

      iex> create_activity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity(attrs \\ %{}) do
    %Activity{ company_id: Repo.get_company_id() }
    |> Activity.changeset(attrs)
    |> Repo.insert()
  end

  def create_activity_group(attrs \\ %{}, opts \\ []) do
    %ActivityGroup{ company_id: Repo.get_company_id() }
    |> ActivityGroup.changeset(attrs)
    |> Repo.insert(opts)
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

  def update_activity_group(%ActivityGroup{} = activity_group, attrs) do
    activity_group
    |> ActivityGroup.changeset(attrs)
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

  def delete_activity_group(%ActivityGroup{} = activity) do
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

  def change_activity_group(%ActivityGroup{} = activity, attrs \\ %{}) do
    ActivityGroup.changeset(activity, attrs)
  end

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
    %ActivityParticipant{ company_id: Repo.get_company_id() }
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

  @spec get_activities_in_time_range(%DateTime{}, %DateTime{}) :: list()
  @doc """
  Retrieves activities between minTime and maxTime.
  """
  def get_activities_in_time_range(minTime, maxTime) do
    from(a in ActivityPlanner.Activities.Activity,
      where: a.start_time >= ^minTime and a.end_time <= ^maxTime
    )
    |> ActivityPlanner.Repo.all()
  end

  def get_activities_for_the_next_two_days(current_time \\ Timex.now()) do
    minTime = current_time
    maxTime = Timex.shift(minTime, days: 2)
    get_activities_in_time_range(minTime, maxTime)
  end

  def get_activities_for_the_last_two_days(current_time \\ Timex.now()) do
    maxTime = current_time
    minTime = Timex.shift(maxTime, days: -2)
    get_activities_in_time_range(minTime, maxTime)
  end
end
