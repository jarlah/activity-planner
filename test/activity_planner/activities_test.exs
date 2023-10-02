defmodule ActivityPlanner.ActivitiesTest do
  use ActivityPlanner.DataCase

  alias ActivityPlanner.Activities.Activity
  alias ActivityPlanner.Activities.ActivityParticipant
  alias ActivityPlanner.Activities.ActivityGroup

  import ActivityPlanner.Activities

  import ActivityPlanner.Factory

  doctest ActivityPlanner.Activities

  @fixed_time ~U[1970-01-01T00:00:00Z]

  describe "get_activities_in_time_range/2" do
    test "retrieves activities within the specified time range" do
      company = insert!(:company)
      responsible_participant = insert!(:participant, company: company)

      _activity0 =
        insert!(
          :activity,
          start_time: Timex.shift(@fixed_time, days: -4),
          end_time: Timex.shift(@fixed_time, days: -3),
          company: company,
          responsible_participant: responsible_participant
        )

      activity1 =
        insert!(
          :activity,
          start_time: @fixed_time,
          end_time: Timex.shift(@fixed_time, days: 1),
          company: company,
          responsible_participant: responsible_participant
        )

      _activity2 =
        insert!(:activity,
          start_time: Timex.shift(@fixed_time, days: 3),
          end_time: Timex.shift(@fixed_time, days: 4),
          company: company,
          responsible_participant: responsible_participant
        )

      minTime = @fixed_time
      maxTime = Timex.shift(@fixed_time, days: 2)

      [%Activity{id: activity_id}] =
        get_activities_in_time_range(minTime, maxTime, skip_company_id: true)

      assert activity_id == activity1.id
    end
  end

  describe "get_activities_for_the_next_two_days/0" do
    test "retrieves activities for the next two days" do
      company = insert!(:company)
      responsible_participant = insert!(:participant, company: company)

      # Create some fixtures with a fixed time
      activity1 =
        insert!(
          :activity,
          start_time: @fixed_time,
          end_time: Timex.shift(@fixed_time, days: 1),
          company: company,
          responsible_participant: responsible_participant
        )

      _activity2 =
        insert!(
          :activity,
          start_time: Timex.shift(@fixed_time, days: 3),
          end_time: Timex.shift(@fixed_time, days: 4),
          company: company,
          responsible_participant: responsible_participant
        )

      [%Activity{id: activity_id}] =
        get_activities_for_the_next_two_days(@fixed_time, skip_company_id: true)

      assert activity_id == activity1.id
    end
  end

  describe "get_activities_for_the_last_two_days/0" do
    test "retrieves activities for the last two days" do
      company = insert!(:company)
      responsible_participant = insert!(:participant, company: company)

      # Create some fixtures with a fixed time
      activity1 =
        insert!(
          :activity,
          start_time: Timex.shift(@fixed_time, days: -1),
          end_time: @fixed_time,
          company: company,
          responsible_participant: responsible_participant
        )

      _activity2 =
        insert!(
          :activity,
          start_time: Timex.shift(@fixed_time, days: 3),
          end_time: Timex.shift(@fixed_time, days: 4),
          company: company,
          responsible_participant: responsible_participant
        )

      [%Activity{id: activity_id}] =
        get_activities_for_the_last_two_days(@fixed_time, skip_company_id: true)

      assert activity_id == activity1.id
    end
  end
end
