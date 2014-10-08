# For calculating which features have been gained or lost when
# a user changes plans
class PlanComparer
  FEATURES = %w(forum shows exercises mentor repositories video_tutorials)

  def initialize(new_plan:, old_plan:)
    @old_plan = old_plan
    @new_plan = new_plan
  end

  def features_gained
    FEATURES.select do |feature|
      !@old_plan.has_feature?(feature) &&
        @new_plan.has_feature?(feature)
    end
  end

  def features_lost
    FEATURES.select do |feature|
      @old_plan.has_feature?(feature) &&
        !@new_plan.has_feature?(feature)
    end
  end
end
