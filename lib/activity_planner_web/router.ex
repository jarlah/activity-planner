defmodule ActivityPlannerWeb.Router do
  use ActivityPlannerWeb, :router

  import ActivityPlannerWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ActivityPlannerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ActivityPlannerWeb do
    pipe_through :browser

    live "/", HomeLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", ActivityPlannerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:activity_planner, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ActivityPlannerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", ActivityPlannerWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{ActivityPlannerWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      # live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      # live "/users/reset_password", UserForgotPasswordLive, :new
      # live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", ActivityPlannerWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{ActivityPlannerWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/activities", ActivityLive.Index, :index
      live "/activities/new", ActivityLive.Index, :new
      live "/activities/:id/edit", ActivityLive.Index, :edit
      live "/activities/:id", ActivityLive.Show, :show
      live "/activities/:id/show/edit", ActivityLive.Show, :edit

      live "/activity_groups", ActivityGroupLive.Index, :index
      live "/activity_groups/new", ActivityGroupLive.Index, :new
      live "/activity_groups/:id/edit", ActivityGroupLive.Index, :edit
      live "/activity_groups/:id", ActivityGroupLive.Show, :show
      live "/activity_groups/:id/show/edit", ActivityGroupLive.Show, :edit

      live "/participants", ParticipantLive.Index, :index
      live "/participants/new", ParticipantLive.Index, :new
      live "/participants/:id/edit", ParticipantLive.Index, :edit
      live "/participants/:id", ParticipantLive.Show, :show
      live "/participants/:id/show/edit", ParticipantLive.Show, :edit

      live "/activity_participants", ActivityParticipantLive.Index, :index
      live "/activity_participants/new", ActivityParticipantLive.Index, :new
      live "/activity_participants/:id/edit", ActivityParticipantLive.Index, :edit
      live "/activity_participants/:id", ActivityParticipantLive.Show, :show
      live "/activity_participants/:id/show/edit", ActivityParticipantLive.Show, :edit
    end
  end

  scope "/", ActivityPlannerWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{ActivityPlannerWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
