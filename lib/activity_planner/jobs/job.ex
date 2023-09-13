defmodule ActivityPlanner.Jobs.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "job" do
    field :cron_expression, :string
    field :name, :string
    field :task_args, {:array, :string}
    field :task_function, :string
    field :task_module, :string

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:name, :cron_expression, :task_module, :task_function, :task_args])
    |> validate_required([:name, :cron_expression, :task_module, :task_function])
  end
end
