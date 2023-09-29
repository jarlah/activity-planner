defmodule ActivityPlanner.FixtureHelpers do
  def get_with_lazy_default(map, key, default_lambda) do
    case Map.get(map, key) do
      nil -> default_lambda.() # Call the lambda only if needed
      value -> value
    end
  end
end
