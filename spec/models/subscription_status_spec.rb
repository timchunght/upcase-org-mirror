require 'spec_helper'

describe SubscriptionStatus do
  describe '#changeable_by_subscriber?' do
    it 'returns true when the subscription is active and not scheduled for cancellation' do
      status = SubscriptionStatus.new(deactivated_on: nil, scheduled_for_cancellation_on: nil)
      expect(status.changeable_by_subscriber?).to be_true

      status = SubscriptionStatus.new(deactivated_on: Date.today, scheduled_for_cancellation_on: Date.today)
      expect(status.changeable_by_subscriber?).to be_false

      status = SubscriptionStatus.new(deactivated_on: nil, scheduled_for_cancellation_on: Date.today)
      expect(status.changeable_by_subscriber?).to be_false

      status = SubscriptionStatus.new(deactivated_on: Date.today, scheduled_for_cancellation_on: nil)
      expect(status.changeable_by_subscriber?).to be_false
    end
  end

  describe '#active?' do
    it "returns true if deactivated_on is nil" do
      subscription = SubscriptionStatus.new(deactivated_on: nil)
      subscription.should be_active
    end

    it "returns false if deactivated_on is not nil" do
      subscription = SubscriptionStatus.new(deactivated_on: Time.zone.today)
      subscription.should_not be_active
    end
  end
end
