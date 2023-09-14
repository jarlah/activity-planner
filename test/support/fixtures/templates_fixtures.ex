defmodule ActivityPlanner.TemplatesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ActivityPlanner.Templates` context.
  """

  @doc """
  Generate a template.
  """
  def template_fixture(attrs \\ %{}) do
    {:ok, template} =
      attrs
      |> Enum.into(%{
        content: "some content",
        name: "some name"
      })
      |> ActivityPlanner.Templates.create_template()

    template
  end
end
