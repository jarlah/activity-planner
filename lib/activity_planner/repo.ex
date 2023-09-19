defmodule ActivityPlanner.Repo do
  use Ecto.Repo,
    otp_app: :activity_planner,
    adapter: Ecto.Adapters.Postgres

  require Ecto.Query

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

  @tenant_key {__MODULE__, :company_id}

  def put_company_id(company_id) do
    Process.put(@tenant_key, company_id)
  end

  def get_company_id() do
    Process.get(@tenant_key)
  end

  @impl true
  def default_options(_operation) do
    [company_id: get_company_id()]
  end
end
