defmodule ActivityPlanner.Accounts.UserAdmin do
  def custom_links(_schema) do
    [
      %{name: "Sign out", url: "/users/log_out", method: :delete, location: :sub, icon: "link", target: "_self"},
    ]
  end
end
