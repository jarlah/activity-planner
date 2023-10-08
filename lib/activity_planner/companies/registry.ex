defmodule ActivityPlanner.Companies.Registry do
  use Ash.Registry,
    extensions: [
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry ActivityPlanner.Companies.Company
  end
end
