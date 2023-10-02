defmodule ActivityPlanner.ActivitiesTest do
  use ActivityPlanner.DataCase

  alias ActivityPlanner.Activities.Activity
  alias ActivityPlanner.Activities.ActivityParticipant
  alias ActivityPlanner.Activities.ActivityGroup

  import ActivityPlanner.Activities

  import ActivityPlanner.ActivityFixtures
  import ActivityPlanner.Factory

  doctest ActivityPlanner.Activities

  @fixed_time ~U[1970-01-01T00:00:00Z]

  describe "get_activities_in_time_range/2" do
    import ActivityPlanner.ActivityFixtures

    test "retrieves activities within the specified time range" do
      _activity0 =
        activity_fixture(%{
          start_time: Timex.shift(@fixed_time, days: -4),
          end_time: Timex.shift(@fixed_time, days: -3)
        })

      activity1 = activity_fixture(%{}, @fixed_time)

      _activity2 =
        activity_fixture(%{
          start_time: Timex.shift(@fixed_time, days: 3),
          end_time: Timex.shift(@fixed_time, days: 4)
        })

      minTime = @fixed_time
      maxTime = Timex.shift(@fixed_time, days: 2)

      [activity_one] =
        get_activities_in_time_range(minTime, maxTime, skip_company_id: true)

      assert activity_one == activity1
    end
  end

  describe "get_activities_for_the_next_two_days/0" do
    import ActivityPlanner.ActivityFixtures

    test "retrieves activities for the next two days" do
      # Create some fixtures with a fixed time
      activity1 =
        activity_fixture(%{
          start_time: @fixed_time,
          end_time: Timex.shift(@fixed_time, days: 1)
        })

      _activity2 =
        activity_fixture(%{
          start_time: Timex.shift(@fixed_time, days: 3),
          end_time: Timex.shift(@fixed_time, days: 4)
        })

      [activity_one] =
        get_activities_for_the_next_two_days(@fixed_time, skip_company_id: true)

      assert activity_one == activity1
    end
  end

  describe "get_activities_for_the_last_two_days/0" do
    import ActivityPlanner.ActivityFixtures

    test "retrieves activities for the last two days" do
      # Create some fixtures with a fixed time
      activity1 =
        activity_fixture(%{
          start_time: Timex.shift(@fixed_time, days: -1),
          end_time: @fixed_time
        })

      _activity2 =
        activity_fixture(%{
          start_time: Timex.shift(@fixed_time, days: 3),
          end_time: Timex.shift(@fixed_time, days: 4)
        })

      [activity_one] =
        get_activities_for_the_last_two_days(@fixed_time, skip_company_id: true)

      assert activity_one == activity1
    end
  end
end
