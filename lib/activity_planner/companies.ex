defmodule ActivityPlanner.Companies do
  alias ActivityPlanner.Companies.Company
  alias ActivityPlanner.Repo

  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end
end
