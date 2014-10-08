# Responsible for fulfilling and unfulfilling features after a user subscribes,
# cancels, or changes their plan
class FeatureFulfillment
  def initialize(feature_factory:, new_plan:, old_plan:)
    @feature_factory = feature_factory
    @plan_comparer = PlanComparer.new(new_plan: new_plan, old_plan: old_plan)
  end

  def fulfill_gained_features
    gained_features.each(&:fulfill)
  end

  def unfulfill_lost_features
    lost_features.each(&:unfulfill)
  end

  private

  attr_reader :feature_factory, :plan_comparer

  def gained_features
    plan_comparer.features_gained.map do |feature_string|
      feature_factory.new(type: feature_string)
    end
  end

  def lost_features
    plan_comparer.features_lost.map do |feature_string|
      feature_factory.new(type: feature_string)
    end
  end
end
