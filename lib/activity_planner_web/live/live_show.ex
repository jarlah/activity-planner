defmodule ActivityPlannerWeb.LiveShow do
  defmacro __using__(options) do
    key = options[:key]
    context = options[:context]

    get_function = :"get_#{key}!"

    title = key
      |> to_string()
      |> String.replace("_", " ")

    quote do
      use ActivityPlannerWeb, :live_view

      @impl true
      def mount(_params, _session, socket) do
        {:ok, socket}
      end

      @impl true
      def handle_params(%{"id" => id}, _, socket) do
        {:noreply,
         socket
         |> assign(:page_title, page_title(socket.assigns.live_action))
         |> assign(:participant, apply(unquote(context), unquote(get_function), [id]))}
      end

      defp page_title(:show), do: "Show #{unquote(title)}"
      defp page_title(:edit), do: "Edit #{unquote(title)}"
    end
  end
end
