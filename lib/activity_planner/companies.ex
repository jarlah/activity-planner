defmodule ActivityPlanner.Companies do
  import Ecto.Changeset

  alias ActivityPlanner.Companies.Company
  alias ActivityPlanner.Repo

  @tenant_key {__MODULE__, :company_id}

  def put_company_id(company_id) do
    Process.put(@tenant_key, company_id)
  end

  def get_company_id() do
    Process.get(@tenant_key)
  end

  def create_company(attrs \\ %{}, opts \\ []) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert(opts)
  end

  def list_companies(opts \\ []) do
    Repo.all(Company, opts)
  end

  def common_changeset(schema, _attrs) do
    schema
    |> put_company_id(get_company_id())
  end

  defp put_company_id(changeset, nil), do: changeset

  defp put_company_id(changeset, company_id) do
    put_change(changeset, :company_id, company_id)
  end
end
