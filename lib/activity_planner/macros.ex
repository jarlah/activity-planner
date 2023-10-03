defmodule ActivityPlanner.Macros do
  @spec call_dynamic(module, atom, any, any, any) :: any
  defmacro call_dynamic(context, function_name, arg1, arg2, arg3) do
    quote do
      unquote(context).unquote(function_name)(unquote(arg1), unquote(arg2), unquote(arg3))
    end
  end

  @spec call_dynamic(module, atom, any, any) :: any
  defmacro call_dynamic(context, function_name, arg1, arg2) do
    quote do
      unquote(context).unquote(function_name)(unquote(arg1), unquote(arg2))
    end
  end

  @spec call_dynamic(module, atom, list) :: any
  defmacro call_dynamic(context, function_name, args) when is_list(args) do
    quote do
      unquote(context).unquote(function_name)(unquote_splicing(args))
    end
  end

  @spec call_dynamic(module, atom, any) :: any
  defmacro call_dynamic(context, function_name, args) do
    quote do
      unquote(context).unquote(function_name)(unquote(args))
    end
  end

  @spec apply_assigns(term, list) :: any
  defmacro apply_assigns(socket, assigns) do
    assign_exprs =
      Enum.map(assigns, fn {name, mod: mod, fun: fun} ->
        quote do
          assign(unquote(name), unquote(mod).unquote(fun)())
        end
      end)

    splicing_expr =
      case assign_exprs do
        [] ->
          quote do: unquote(socket)

        _ ->
          Enum.reduce(
            assign_exprs,
            socket,
            fn expr, acc ->
              quote do
                unquote(acc) |> unquote(expr)
              end
            end
          )
      end

    splicing_expr
  end
end
