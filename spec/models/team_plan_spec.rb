require 'spec_helper'

describe TeamPlan do
  it { should have_many(:purchases) }
  it { should have_many(:subscriptions) }

  it { should validate_presence_of(:sku) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
end
