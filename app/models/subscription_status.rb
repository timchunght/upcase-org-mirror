class SubscriptionStatus
  # TODO: pass attributes instead
  def initialize(subscription_attributes)
    @deactivated_on = subscription_attributes[:deactivated_on]
    @scheduled_for_cancellation_on = subscription_attributes[:scheduled_for_cancellation_on]
  end

  def changeable_by_subscriber?
    active? && !scheduled_for_cancellation?
  end

  def active?
    @deactivated_on.nil?
  end

  private

  def scheduled_for_cancellation?
    @scheduled_for_cancellation_on.present?
  end

end
