require "rails_helper"

describe Analytics do
  describe "#track_cancelled" do
    it "sends cancelled event to backend" do
      user = build(:user)
      user_analytics = Analytics.new(user)

      user_analytics.track_cancelled

      expect(analytics).to have_tracked("Cancelled").for_user(user)
    end
  end

  describe "#track_updated" do
    it "sends updated identify event to backend" do
      user = build_stubbed(:user)
      user_analytics = Analytics.new(user)

      user_analytics.track_updated

      expect(analytics).to have_identified(user).
        with_properties(user_analytics.identify_hash(user))
    end
  end
end
