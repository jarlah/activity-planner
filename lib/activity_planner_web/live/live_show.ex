defmodule ActivityPlannerWeb.LiveShow do
  require ActivityPlanner.Macros
  import ActivityPlanner.Macros, only: [call_dynamic: 3]

  defmacro __using__(options) do
    key = options[:key]
    env = __CALLER__
    context = Macro.expand(options[:context], env)
    assigns = options[:assigns] || []

    get_function = :"get_#{key}!"

    title =
      key
      |> to_string()
      |> String.replace("_", " ")

    assign_exprs =
      Enum.map(assigns, fn {name, mod: mod, fun: fun} ->
        quote do
          assign(unquote(name), call_dynamic(unquote(mod), unquote(fun), []))
        end
      end)

    quote do
      use ActivityPlannerWeb, :live_view

      @impl true
      def mount(_params, _session, socket) do
        socket
        |> unquote(splicing_expr(assign_exprs))
        |> Kernel.then(&{:ok, &1})
      end

      @impl true
      def handle_params(%{"id" => id}, _, socket) do
        {:noreply,
         socket
         |> assign(:page_title, page_title(socket.assigns.live_action))
         |> assign(unquote(key), call_dynamic(unquote(context), unquote(get_function), id))}
      end

      defp page_title(:show), do: "Show #{unquote(title)}"
      defp page_title(:edit), do: "Edit #{unquote(title)}"
    end
  end

  defp splicing_expr(exprs) do
    case exprs do
      [] ->
        quote do
        end

      _ ->
        Enum.reduce(
          exprs,
          quote do
          end,
          fn expr, acc ->
            quote do
              unquote(acc) |> unquote(expr)
            end
          end
        )
    end
  end
end
