defmodule ActivityPlanner.Companies do
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
end
