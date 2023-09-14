# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :activity_planner,
  ecto_repos: [ActivityPlanner.Repo]

# Configures the endpoint
config :activity_planner, ActivityPlannerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: ActivityPlannerWeb.ErrorHTML, json: ActivityPlannerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ActivityPlanner.PubSub,
  live_view: [signing_salt: "Q7VdJ6H5"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :activity_planner, ActivityPlanner.Mailer,
  adapter: Swoosh.Adapters.Local,
  from_email: {"Activity Planner", "admin@example.com"}

config :activity_planner, :clicksend,
  enabled: false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :kaffy,
  # required keys
  otp_app: :activity_planner, # required
  ecto_repo: ActivityPlanner.Repo, # required
  router: ActivityPlannerWeb.Router, # required
  # optional keys
  admin_title: "My Awesome App",
  admin_logo: "/images/logo.svg",
  admin_logo_mini: "/images/logo.svg",
  hide_dashboard: true,
  home_page: [schema: [:accounts, :user]],
  enable_context_dashboards: true, # since v0.10.0
  admin_footer: "Kaffy &copy; 2023" # since v0.10.0

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
