defmodule ActivityPlannerWeb.LiveIndex do
  require ActivityPlanner.Macros
  import ActivityPlanner.Macros

  defmacro __using__(options) do
    key = options[:key]
    context = options[:context]

    schema = options[:schema]
    assigns = options[:assigns] || []
    form = options[:form]

    get_function = :"get_#{key}!"
    delete_function = :"delete_#{key}"
    list_function = :"list_#{Inflex.pluralize(key)}"

    stream_key = key |> Inflex.pluralize() |> String.to_atom()

    title =
      key
      |> to_string()
      |> String.replace("_", " ")

    quote do
      use ActivityPlannerWeb, :live_view

      @impl true
      def mount(_params, _session, socket) do
        socket
        |> stream(unquote(stream_key), call_dynamic(unquote(context), unquote(list_function), []))
        |> apply_assigns(unquote(assigns))
        |> Kernel.then(&{:ok, &1})
      end

      @impl true
      def handle_params(params, _url, socket) do
        {:noreply, apply_action(socket, socket.assigns.live_action, params)}
      end

      defp apply_action(socket, :edit, %{"id" => id}) do
        socket
        |> assign(:page_title, "Edit #{unquote(title)}")
        |> assign(unquote(key), call_dynamic(unquote(context), unquote(get_function), [id]))
      end

      defp apply_action(socket, :new, _params) do
        socket
        |> assign(:page_title, "New #{unquote(title)}")
        |> assign(unquote(key), %unquote(schema){})
      end

      defp apply_action(socket, :index, _params) do
        socket
        |> assign(:page_title, "Listing #{unquote(title) |> Inflex.pluralize()}")
        |> assign(unquote(key), nil)
      end

      @impl true
      def handle_info({unquote(form), {:saved, obj}}, socket) do
        {:noreply, stream_insert(socket, unquote(stream_key), obj)}
      end

      @impl true
      def handle_event("delete", %{"id" => id}, socket) do
        obj = call_dynamic(unquote(context), unquote(get_function), [id])
        {:ok, _} = call_dynamic(unquote(context), unquote(delete_function), [obj])

        {:noreply,
         stream_delete(socket, unquote(stream_key), obj)
         |> put_flash(:info, (unquote(title) |> String.capitalize()) <> " deleted successfully")}
      end
    end
  end
end
