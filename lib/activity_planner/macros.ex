defmodule ActivityPlanner.Macros do
  @spec call_dynamic(module, atom, any, any, any) :: any()
  defmacro call_dynamic(context, function_name, arg1, arg2, arg3) do
    quote do
      unquote(context).unquote(function_name)(unquote(arg1), unquote(arg2), unquote(arg3))
    end
  end

  @spec call_dynamic(module, atom, any, any) :: any()
  defmacro call_dynamic(context, function_name, arg1, arg2) do
    quote do
      unquote(context).unquote(function_name)(unquote(arg1), unquote(arg2))
    end
  end

  @spec call_dynamic(module, atom, list) :: any()
  defmacro call_dynamic(context, function_name, args) when is_list(args) do
    quote do
      unquote(context).unquote(function_name)(unquote_splicing(args))
    end
  end

  @spec call_dynamic(module, atom, any) :: any()
  defmacro call_dynamic(context, function_name, args) do
    quote do
      unquote(context).unquote(function_name)(unquote(args))
    end
  end
end
