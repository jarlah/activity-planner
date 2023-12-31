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

      iex> activity = insert!(:activity)
      iex> [%Activity{}] = list_activities(company_id: activity.company_id)
      iex> [%Activity{}] = list_activities(skip_company_id: true)
      iex> non_existent_company_id = Ecto.UUID.generate()
      iex> list_activities(company_id: non_existent_company_id)
      []

  """
  def list_activities(options \\ []) do
    Repo.all(Activity, options)
  end

  @doc """
  Returns the list of activity groups.

  ## Examples

      iex> activity_group = insert!(:activity_group)
      iex> [%ActivityGroup{}] = list_activity_groups(company_id: activity_group.company_id)
      iex> [%ActivityGroup{}] = list_activity_groups(skip_company_id: true)
      iex> non_existent_company_id = Ecto.UUID.generate()
      iex> list_activity_groups(company_id: non_existent_company_id)
      []

  """
  def list_activity_groups(options \\ []) do
    Repo.all(ActivityGroup, options)
  end

  @doc """
  Gets a single activity.

  ## Example

      iex> activity = insert!(:activity)
      iex> get_activity!(activity.id, company_id: activity.company_id)

  Raises `Ecto.NoResultsError` if the Activity does not exist.
  """
  def get_activity!(id, options \\ []), do: Repo.get!(Activity, id, options)

  @doc """
  Gets a single activity group.

  ## Example

      iex> activity_group = insert!(:activity_group)
      iex> get_activity_group!(activity_group.id, company_id: activity_group.company_id)

  Raises `Ecto.NoResultsError` if the Activity does not exist.
  """
  def get_activity_group!(id, options \\ []), do: Repo.get!(ActivityGroup, id, options)

  @doc """
  Creates a activity.

    ## Example

      iex> company = insert!(:company)
      iex> participant = insert!(:participant, company: company)
      iex> activity_group = insert!(:activity_group, company: company)
      iex> start_time = Timex.now()
      iex> end_time = Timex.shift(start_time, hours: 24)
      iex> attrs = %{ responsible_participant_id: participant.id, activity_group_id: activity_group.id, start_time: start_time, end_time: end_time }
      iex> {:ok, %Activity{}} = create_activity(attrs, company_id: company.company_id)

  """
  def create_activity(attrs \\ %{}, opts \\ []) do
    %Activity{}
    |> Activity.changeset(attrs, opts)
    |> Repo.insert(opts)
  end

  @doc """
  Creates a activity.

    ## Examples

      iex> company = insert!(:company)
      iex> participant = insert!(:participant, company: company)
      iex> activity_group = insert!(:activity_group, company: company)
      iex> start_time = Timex.now()
      iex> end_time = Timex.shift(start_time, hours: 24)
      iex> attrs = %{ responsible_participant_id: participant.id, activity_group_id: activity_group.id, start_time: start_time, end_time: end_time }
      iex> %Activity{} = create_activity!(attrs, company_id: company.company_id)
      iex> assert {:error, %Ecto.Changeset{}} = create_activity(%{description: nil, start_time: nil, end_time: nil})

  """
  def create_activity!(attrs \\ %{}, opts \\ []) do
    {:ok, activity} = create_activity(attrs, opts)
    activity
  end

  @doc """
  Creates a activity group.

      ## Examples

      iex> company = insert!(:company)
      iex> {:ok, %ActivityGroup{}} = create_activity_group(%{ name: "Test" }, company_id: company.company_id)

  """
  def create_activity_group(attrs \\ %{}, opts \\ []) do
    %ActivityGroup{}
    |> ActivityGroup.changeset(attrs, opts)
    |> Repo.insert(opts)
  end

  @doc """
  Updates a activity.

      ## Examples

      iex> activity = insert!(:activity)
      iex> {:ok, %Activity{}} = update_activity(activity, %{ end_time: Timex.shift(activity.start_time, days: 2) })
  """
  def update_activity(%Activity{} = activity, attrs, options \\ []) do
    activity
    |> Activity.changeset(attrs)
    |> Repo.update(options)
  end

  @doc """
  Updates a activity group.

      ## Examples

      iex> activity_group = insert!(:activity_group)
      iex> {:ok, %ActivityGroup{ name: "another name"}} = update_activity_group(activity_group, %{ name: "another name" })
  """
  def update_activity_group(%ActivityGroup{} = activity_group, attrs) do
    activity_group
    |> ActivityGroup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a activity.

  ## Example

      iex> activity = insert!(:activity)
      iex> {:ok, %Activity{}} = delete_activity(activity, company_id: activity.company_id)

  """
  def delete_activity(%Activity{} = activity, options \\ []) do
    Repo.delete(activity, options)
  end

  @doc """
  Deletes a activity group.

  ## Example

      iex> activity_group = insert!(:activity_group)
      iex> {:ok, %ActivityGroup{}} = delete_activity_group(activity_group, company_id: activity_group.company_id)

  """
  def delete_activity_group(%ActivityGroup{} = activity, options \\ []) do
    Repo.delete(activity, options)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity changes.
  """
  def change_activity(%Activity{} = activity, attrs \\ %{}, opts \\ []) do
    Activity.changeset(activity, attrs, opts)
  end

  def change_activity_group(%ActivityGroup{} = activity, attrs \\ %{}, opts \\ []) do
    ActivityGroup.changeset(activity, attrs, opts)
  end

  @doc """
  Returns the list of activity_participants.
  """
  def list_activity_participants(options \\ []) do
    Repo.all(ActivityParticipant, options)
  end

  @doc """
  Gets a single activity_participant.

  Raises `Ecto.NoResultsError` if the Activity participant does not exist.
  """
  def get_activity_participant!(id, options \\ []),
    do: Repo.get!(ActivityParticipant, id, options)

  @doc """
  Creates a activity_participant.

  """
  def create_activity_participant(attrs \\ %{}, opts \\ []) do
    %ActivityParticipant{}
    |> ActivityParticipant.changeset(attrs, opts)
    |> Repo.insert()
  end

  @doc """
  Updates a activity_participant.
  """
  def update_activity_participant(%ActivityParticipant{} = activity_participant, attrs) do
    activity_participant
    |> ActivityParticipant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a activity_participant.
  """
  def delete_activity_participant(%ActivityParticipant{} = activity_participant) do
    Repo.delete(activity_participant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity_participant changes.

  ## Examples

      iex> id1 = Ecto.UUID.cast!("ec8b4aaa-52a3-4222-9ae0-40e718af2dd1")
      iex> id2 = Ecto.UUID.cast!("ec8b4aaa-52a3-4222-9ae0-40e718af2dd2")
      iex> id3 = Ecto.UUID.cast!("ec8b4aaa-52a3-4222-9ae0-40e718af2dd3")
      iex> change_activity_participant(%ActivityParticipant{}, %{activity_id: id1, participant_id: id2}, company_id: id3)
      #Ecto.Changeset<action: nil, changes: %{company_id: "ec8b4aaa-52a3-4222-9ae0-40e718af2dd3", activity_id: "ec8b4aaa-52a3-4222-9ae0-40e718af2dd1", participant_id: "ec8b4aaa-52a3-4222-9ae0-40e718af2dd2"}, errors: [], data: #ActivityPlanner.Activities.ActivityParticipant<>, valid?: true>

  """
  def change_activity_participant(
        %ActivityParticipant{} = activity_participant,
        attrs \\ %{},
        opts \\ []
      ) do
    ActivityParticipant.changeset(activity_participant, attrs, opts)
  end

  @spec get_activities_in_time_range(%DateTime{}, %DateTime{}) :: list()
  @doc """
  Retrieves activities between minTime and maxTime.
  """
  def get_activities_in_time_range(minTime, maxTime, options \\ []) do
    from(a in ActivityPlanner.Activities.Activity,
      where: a.start_time >= ^minTime and a.end_time <= ^maxTime
    )
    |> Repo.all(options)
  end

  def get_activities_for_the_next_two_days(current_time \\ Timex.now(), options \\ []) do
    minTime = current_time
    maxTime = Timex.shift(minTime, days: 2)
    get_activities_in_time_range(minTime, maxTime, options)
  end

  def get_activities_for_the_last_two_days(current_time \\ Timex.now(), options \\ []) do
    maxTime = current_time
    minTime = Timex.shift(maxTime, days: -2)
    get_activities_in_time_range(minTime, maxTime, options)
  end
end
