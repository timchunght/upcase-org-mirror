class SubscriptionFulfillment
  def initialize(user, plan)
    @user = user
    @plan = plan
  end

  def fulfill
    fulfill_gained_features
    download_public_keys
    update_next_invoice_info
  end

  def remove
    unfulfill_lost_features
    remove_licenses
  end

  private

  def fulfill_gained_features
    FeatureFulfillment.new(
      feature_factory: feature_factory,
      old_plan: NullPlan.new,
      new_plan: @plan
    ).fulfill_gained_features
  end

  def unfulfill_lost_features
    FeatureFulfillment.new(
      feature_factory: feature_factory,
      old_plan: @plan,
      new_plan: NullPlan.new
    ).unfulfill_lost_features
  end

  def feature_factory
    Features::Factory.new(user: @user)
  end

  def update_next_invoice_info
    SubscriptionUpcomingInvoiceUpdater.new([@user.subscription]).process
  end

  def download_public_keys
    GitHubPublicKeyDownloadFulfillmentJob.enqueue(@user.id)
  end

  def remove_licenses
    @user.licenses.destroy
  end
end
