defmodule ActivityPlanner.Companies do
  import Ecto.Changeset

  alias ActivityPlanner.Companies.Company
  alias ActivityPlanner.Repo

  def create_company(attrs \\ %{}, opts \\ []) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert(opts)
  end

  def list_companies(opts \\ []) do
    Repo.all(Company, opts)
  end

  def common_changeset(schema, _attrs, opts \\ []) do
    company_id = Repo.get_company_id() || opts[:company_id]
    schema
    |> put_company_id(company_id)
  end

  defp put_company_id(changeset, nil), do: changeset
  defp put_company_id(changeset, company_id) do
    put_change(changeset, :company_id, company_id)
  end
end
