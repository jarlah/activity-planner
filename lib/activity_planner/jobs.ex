defmodule ActivityPlanner.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false
  alias ActivityPlanner.Repo

  alias ActivityPlanner.Jobs.Job

  @doc """
  Returns the list of job.

  ## Examples

      iex> list_job()
      [%Job{}, ...]

  """
  def list_job do
    Repo.all(Job)
  end

  @doc """
  Gets a single job.

  Raises `Ecto.NoResultsError` if the Job does not exist.

  ## Examples

      iex> get_job!(123)
      %Job{}

      iex> get_job!(456)
      ** (Ecto.NoResultsError)

  """
  def get_job!(id), do: Repo.get!(Job, id)

  @doc """
  Creates a job.

  ## Examples

      iex> create_job(%{field: value})
      {:ok, %Job{}}

      iex> create_job(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_job(attrs \\ %{}) do
    changeset = %Job{}
    |> Job.changeset(attrs)

    case Repo.insert(changeset) do
      {:ok, job} ->
        ActivityPlanner.JobManager.add_job(job)
        {:ok, job}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a job.

  ## Examples

      iex> update_job(job, %{field: new_value})
      {:ok, %Job{}}

      iex> update_job(job, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_job(%Job{} = job, attrs) do
    changeset = Job.changeset(job, attrs)

    case Repo.update(changeset) do
      {:ok, updated_job} ->
        ActivityPlanner.JobManager.add_job(updated_job)
        {:ok, updated_job}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Deletes a job.

  ## Examples

      iex> delete_job(job)
      {:ok, %Job{}}

      iex> delete_job(job)
      {:error, %Ecto.Changeset{}}

  """
  def delete_job(%Job{} = job) do
    ActivityPlanner.JobManager.delete_job(job.name)
    Repo.delete(job)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job changes.

  ## Examples

      iex> change_job(job)
      %Ecto.Changeset{data: %Job{}}

  """
  def change_job(%Job{} = job, attrs \\ %{}) do
    Job.changeset(job, attrs)
  end
end
