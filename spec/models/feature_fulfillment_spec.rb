require "rails_helper"

describe FeatureFulfillment do
  describe "#fulfill_gained_features" do
    it "calls #fulfill on each gained feature" do
      old_plan = build_stubbed(:plan, :no_mentor)
      new_plan = build_stubbed(:plan, :includes_mentor)
      mentor_feature = stub_mentor_feature
      feature_factory = stub_feature_factory(mentor: mentor_feature)

      FeatureFulfillment.new(
        feature_factory: feature_factory,
        new_plan: new_plan,
        old_plan: old_plan
      ).fulfill_gained_features

      expect(mentor_feature).to have_received(:fulfill)
    end
  end

  describe "#unfulfill_lost_features" do
    it "calls #unfulfill on each lost feature" do
      old_plan = create(:plan, :includes_mentor)
      new_plan = create(:plan, :no_mentor)
      mentor_feature = stub_mentor_feature
      feature_factory = stub_feature_factory(mentor: mentor_feature)

      FeatureFulfillment.new(
        feature_factory: feature_factory,
        new_plan: new_plan,
        old_plan: old_plan
      ).unfulfill_lost_features

      expect(mentor_feature).to have_received(:unfulfill)
    end
  end

  def stub_mentor_feature
    stub(fulfill: nil, unfulfill: nil).tap do |mentor_feature|
      Features::Mentor.stubs(:new).returns(mentor_feature)
    end
  end

  def stub_feature_factory(features)
    features.inject(stub("feature_factory")) do |factory, (type, result)|
      factory.stubs(:new).with(type: type.to_s).returns(result)
      factory
    end
  end
end
