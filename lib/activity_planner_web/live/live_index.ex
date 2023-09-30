defmodule ActivityPlannerWeb.LiveIndex do
  defmacro __using__(options) do
    key = options[:key]
    env = __CALLER__
    context = Macro.expand(options[:context], env)
    schema = options[:schema]
    assigns = options[:assigns] || []
    form = options[:form]

    get_function = :"get_#{key}!"
    delete_function = :"delete_#{key}"
    list_function = :"list_#{Inflex.pluralize(key)}"

    case Code.ensure_compiled(context) do
      {:module, _} ->
        for {function, arity} <- [
              {get_function, 1},
              {delete_function, 1},
              {list_function, 0}
            ] do
          unless function_exported?(context, function, arity) do
            raise "The function #{function}/#{arity} is required but not defined in #{context}"
          end
        end

      _ ->
        raise "Unable to compile #{context}"
    end

    stream_key = key |> Inflex.pluralize() |> String.to_atom()

    title =
      key
      |> to_string()
      |> String.replace("_", " ")

    assign_exprs =
      Enum.map(assigns, fn {name, mod: mod, fun: fun} ->
        quote do
          assign(unquote(name), unquote(mod).unquote(fun)())
        end
      end)

    quote do
      use ActivityPlannerWeb, :live_view

      @impl true
      def mount(_params, _session, socket) do
        socket
        |> stream(unquote(stream_key), apply(unquote(context), unquote(list_function), []))
        |> unquote(splicing_expr(assign_exprs))
        |> Kernel.then(&{:ok, &1})
      end

      @impl true
      def handle_params(params, _url, socket) do
        {:noreply, apply_action(socket, socket.assigns.live_action, params)}
      end

      defp apply_action(socket, :edit, %{"id" => id}) do
        socket
        |> assign(:page_title, "Edit #{unquote(title)}")
        |> assign(unquote(key), apply(unquote(context), unquote(get_function), [id]))
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
        obj = apply(unquote(context), unquote(get_function), [id])
        {:ok, _} = apply(unquote(context), unquote(delete_function), [obj])

        {:noreply,
         stream_delete(socket, unquote(stream_key), obj)
         |> put_flash(:info, (unquote(title) |> String.capitalize()) <> " deleted successfully")}
      end
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
