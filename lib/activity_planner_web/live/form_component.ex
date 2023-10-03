defmodule ActivityPlannerWeb.FormComponent do
  defmacro __using__(options) do
    key = options[:key]
    env = __CALLER__
    context = Macro.expand(options[:context], env)

    key_string = Atom.to_string(key)

    create_function = :"create_#{key}"
    change_function = :"change_#{key}"
    update_function = :"update_#{key}"

    title =
      key
      |> to_string()
      |> String.replace("_", " ")
      |> String.capitalize()

    quote do
      use ActivityPlannerWeb, :live_component

      @impl true
      def update(%{unquote(key) => obj} = assigns, socket) do
        changeset = unquote(context).unquote(change_function)(obj)

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
          |> unquote(context).unquote(change_function)(params)
          |> Map.put(:action, :validate)

        {:noreply, assign_form(socket, changeset)}
      end

      def handle_event("save", %{unquote(key_string) => params}, socket) do
        action = socket.assigns.action
        entity = Map.get(socket.assigns, unquote(key))

        save_entity(socket, action, entity, params)
      end

      defp save_entity(socket, :edit, entity, params) do
        case unquote(context).unquote(update_function)(entity, params) do
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
        case unquote(context).unquote(create_function)(params) do
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
