defmodule ActivityPlanner.NotificationsTest do
  use ActivityPlanner.DataCase

  alias ActivityPlanner.Notifications.NotificationSchedule
  alias ActivityPlanner.Notifications.NotificationTemplate

  import ActivityPlanner.Notifications
  import ActivityPlanner.NotificationScheduleFixtures
  import ActivityPlanner.NotificationTemplateFixtures
  import ActivityPlanner.CompanyFixtures

  doctest ActivityPlanner.Notifications
end
