defmodule ActivityPlannerWeb.Components.CalendarComponent do
  use Phoenix.Component
  use ActivityPlannerWeb, :verified_routes

  def calendar(assigns) do
    current_date = Date.utc_today()

    [rows, first, last] = week_rows(current_date)

    events = assigns[:events] || ActivityPlanner.Activities.get_activities_in_time_range(
      date_to_datetime(first),
      date_to_datetime(last)
    )

    assigns =
      assigns
      |> assign(:current_date, current_date)
      |> assign(:selected_date, assigns[:selected_date])
      |> assign(:events, events)
      |> assign(:week_rows, rows)

    ~H"""
      <div>
        <%!--<div>
          <h3><%= Calendar.strftime(@current_date, "%B %Y") %></h3>
          <div>
            <button type="button" phx-target={"/"} phx-click="prev-month">&laquo; Prev</button>
            <button type="button" phx-target={"/"} phx-click="next-month">Next &raquo;</button>
          </div>
        </div>--%>

        <table>
          <thead>
            <tr>
              <th :for={week_day <- List.first(@week_rows)}>
                <%= Calendar.strftime(week_day, "%a") %>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr :for={week <- @week_rows}>
              <td :for={day <- week} class={[
                "text-center",
                today?(day) && "bg-green-100",
                other_month?(day, @current_date) && "bg-gray-100",
                selected_date?(day, @selected_date) && "bg-blue-100"
              ]}>
                <% matching_event = @events |> Enum.find(fn event ->
                  NaiveDateTime.to_date(event.start_time) == day
                end) %>
                <.link :if={matching_event} navigate={~p"/admin/activities/activity/#{matching_event.id}"}>
                  <time datetime={Calendar.strftime(day, "%Y-%m-%d")}><%= Calendar.strftime(day, "%d") %></time>
                </.link>
                <time :if={matching_event == nil} datetime={Calendar.strftime(day, "%Y-%m-%d")}><%= Calendar.strftime(day, "%d") %></time>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    """
  end

  @week_start_at :monday

  defp week_rows(current_date) do
    first =
      current_date
      |> Date.beginning_of_month()
      |> Date.beginning_of_week(@week_start_at)

    last =
      current_date
      |> Date.end_of_month()
      |> Date.end_of_week(@week_start_at)

    rows =
      Date.range(first, last)
      |> Enum.map(& &1)
      |> Enum.chunk_every(7)

    [rows, first, last]
  end

  defp selected_date?(day, selected_date), do: day == selected_date

  defp today?(day), do: day == Date.utc_today()

  defp other_month?(day, current_date), do: Date.beginning_of_month(day) != Date.beginning_of_month(current_date)

  defp date_to_datetime(date) do
    DateTime.new!(date, ~T[00:00:00.000], "Etc/UTC")
  end
end
