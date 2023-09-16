defmodule ActivityPlanner.Activities.ActivityAdmin do
  def custom_pages(_schema, _conn) do
    [
      %{
        slug: "calendar",
        name: "Calendar",
        view: ActivityPlanner.View.CalendarView,
        template: "index.html"
      }
    ]
  end
end
