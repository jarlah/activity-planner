defmodule ActivityPlannerWeb.FormComponent do
  require ActivityPlanner.Macros
  import ActivityPlanner.Macros

  defmacro __using__(options) do
    key = options[:key]
    context = options[:context]

    key_string = "#{key}"

    create_function = :"create_#{key_string}"
    change_function = :"change_#{key_string}"
    update_function = :"update_#{key_string}"

    title =
      key
      |> to_string()
      |> String.replace("_", " ")
      |> String.capitalize()

    quote do
      use ActivityPlannerWeb, :live_component

      @impl true
      def update(%{unquote(key) => obj} = assigns, socket) do
        changeset = call_dynamic(unquote(context), unquote(change_function), [obj])

        {:ok,
         socket
         |> assign(assigns)
         |> assign_form(changeset)}
      end

      @impl true
      def handle_event("validate", %{unquote(key_string) => params}, socket) do
        entity = Map.fetch!(socket.assigns, unquote(key))

        changeset =
          entity
          # we cannot chain as we usually do with the pipe operator
          # because call_dynamic is an overloaded macro method
          # normally we would do something like
          # |> SomeContext.do_stuff(params)
          # and entity would be stitched in a the front
          # so we need to use the Kernel.then helper method
          |> Kernel.then(fn entity ->
            call_dynamic(unquote(context), unquote(change_function), [entity, params])
          end)
          |> Map.put(:action, :validate)

        {:noreply, assign_form(socket, changeset)}
      end

      def handle_event("save", %{unquote(key_string) => params}, socket) do
        action = socket.assigns.action
        entity = Map.get(socket.assigns, unquote(key))

        save_entity(socket, action, entity, params)
      end

      defp save_entity(socket, :edit, entity, params) do
        case call_dynamic(unquote(context), unquote(update_function), [entity, params]) do
          {:ok, entity} ->
            notify_parent({:saved, entity})

            {:noreply,
             socket
             |> put_flash(:info, "#{unquote(title)} updated successfully")
             |> push_patch(to: socket.assigns.patch)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign_form(socket, changeset)}
        end
      end

      defp save_entity(socket, :new, _nil, params) do
        case call_dynamic(unquote(context), unquote(create_function), [params]) do
          {:ok, entity} ->
            notify_parent({:saved, entity})

            {:noreply,
             socket
             |> put_flash(:info, "#{unquote(title)} created successfully")
             |> push_patch(to: socket.assigns.patch)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign_form(socket, changeset)}
        end
      end

      defp assign_form(socket, %Ecto.Changeset{} = changeset),
        do: assign(socket, :form, to_form(changeset))

      defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
    end
  end
end
