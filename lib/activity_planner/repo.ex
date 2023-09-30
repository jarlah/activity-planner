defmodule ActivityPlanner.Repo do
  use Ecto.Repo,
    otp_app: :activity_planner,
    adapter: Ecto.Adapters.Postgres

  require Ecto.Query

  alias ActivityPlanner.Companies

  @impl true
  def prepare_query(_operation, query, opts) do
    cond do
      opts[:skip_company_id] || opts[:schema_migration] ->
        {query, opts}

      company_id = opts[:company_id] ->
        {Ecto.Query.where(query, company_id: ^company_id), opts}

      true ->
        raise "expected company_id or skip_company_id to be set"
    end
  end

  @impl true
  def default_options(_operation) do
    [company_id: Companies.get_company_id()]
  end
end
