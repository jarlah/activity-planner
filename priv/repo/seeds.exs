# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ActivityPlanner.Repo.insert!(%ActivityPlanner.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

password_length = 12
admin_email = "admin@example.com"

case ActivityPlanner.Accounts.get_user_by_email(admin_email) do
  nil ->
    # Generate a strong random password
    random_bytes = :crypto.strong_rand_bytes(password_length)
    strong_password = Base.encode64(random_bytes) |> String.slice(0, password_length)

    IO.puts("Generated admin password: #{strong_password}")

    user_params = %{
      email: admin_email,
      password: strong_password,
      is_admin: true
    }

    {:ok, _user} = ActivityPlanner.Accounts.register_user(user_params)

  _ ->
    IO.puts("Admin user already exists, skipping.")
end
