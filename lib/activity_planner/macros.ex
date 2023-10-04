defmodule ActivityPlanner.Macros do

  @doc """
  Inline a call to a method on a context at compile time.

  Example:

  call_dynamic(ActivityPlanner.Activities, :list_activities, [])

  call_dynamic(ActivityPlanner.Activities, :get_activity!, [id])

  This will expand to

  ActivityPlanner.Activities.list_activities()

  ActivityPlanner.Activities.get_activity!(id)

  Which will fail to compile if those methods and arities doesnt exist.
  """
  @spec call_dynamic(module, atom, list) :: any
  defmacro call_dynamic(context, function_name, args) when is_list(args) do
    quote do
      unquote(context).unquote(function_name)(unquote_splicing(args))
    end
  end

  @doc """
  Apply multiple assigns to a socket dynamically.

  Example:

  socket
  |> apply_assigns([
    {:activity_groups, mod: ActivityPlanner.Activities, fun: :list_activity_groups},
    {:participants, mod: ActivityPlanner.Participants, fun: :list_participants}
  ])

  This will expand to

  socket
  |> assign(:activity_groups, ActivityPlanner.Activities.list_activity_groups())
  |> assign(:participants, ActivityPlanner.Participants.list_participants())

  """
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
