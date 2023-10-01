defmodule ActivityPlanner.Factory do
  alias ActivityPlanner.Repo

  # Factories

  defp build(:company) do
    %ActivityPlanner.Companies.Company{
      name: "Name",
      description: "Description",
      address: "Address"
    }
  end

  defp build(:participant) do
    %ActivityPlanner.Participants.Participant{
      name: "Name",
      description: "Description",
      email: "email@email.com",
      phone: "12345678"
    }
  end

  defp build(:activity_group) do
    %ActivityPlanner.Activities.ActivityGroup{
      name: "Name",
      description: "Description"
    }
  end

  defp build(:activity) do
    %ActivityPlanner.Activities.Activity{
      title: "Title",
      description: "Description",
      start_time: Timex.now(),
      end_time: Timex.shift(Timex.now(), days: 2)
    }
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
