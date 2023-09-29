defmodule ActivityPlanner.CompanyFixtures do
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        name: "some title",
        address: "some address",
        description: "some description"
      })
      |> ActivityPlanner.Companies.create_company()

    company
  end
end
