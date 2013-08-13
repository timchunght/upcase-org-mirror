require 'spec_helper'

describe Plan do
  it { should have_many(:announcements) }
  it { should have_many(:purchases) }
  it { should have_many(:subscriptions) }

  it { should validate_presence_of(:company_price) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:individual_price) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:short_description) }
  it { should validate_presence_of(:sku) }

  it { should_not be_fulfilled_with_github }
  it { should be_subscription }

  describe '.active' do
    it 'only includes active plans' do
      active = create(:plan, active: true)
      inactive = create(:plan, active: false)
      expect(Plan.active).to eq [active]
    end
  end

  describe '.featured' do
    it 'only featured plans' do
      featured = create(:plan, featured: true)
      notfeatured = create(:plan, featured: false)
      expect(Plan.featured).to eq [featured]
    end
  end

  describe '.ordered' do
    it 'sorts by individual price' do
      second = create(:plan, individual_price: 29)
      first = create(:plan, individual_price: 99)
      expect(Plan.ordered).to eq [first, second]
    end
  end

  describe '.default' do
    it 'returns the first, active, featured, ordered plan' do
      ordered = stub(first: stub())
      featured = stub(ordered: ordered)
      active = stub(featured: featured)
      Plan.stubs(active: active)

      Plan.default

      expect(ordered).to have_received(:first)
      expect(featured).to have_received(:ordered)
      expect(active).to have_received(:featured)
      expect(Plan).to have_received(:active)
    end
  end

  describe '.prime_basic' do
    it 'returns the instance of Plan corresponding to Prime Basic' do
      create_prime_basic_plan

      expect(Plan.prime_basic).to eq Plan.find_by_sku(Plan::PRIME_BASIC_SKU)
    end
  end

  describe '.prime_workshops' do
    it 'returns the Plan instance corresponding to Prime Workshops' do
      create_prime_workshops_plan

      expect(Plan.prime_workshops).to eq Plan.find_by_sku(Plan::PRIME_WORKSHOPS_SKU)
    end
  end

  describe '.prime_with_mentoring' do
    it 'returns the Plan instance corresponding to Prime with Mentoring' do
      create_prime_with_mentoring_plan

      expect(Plan.prime_with_mentoring).to eq Plan.find_by_sku(Plan::PRIME_WITH_MENTORING_SKU)
    end
  end

  describe '.prime_basic_subscription_count' do
    it 'returns 0 when there are no active subscriptions to the Prime Basic plan' do
      plan = create_prime_basic_plan
      create_inactive_subscription_for(plan)

      expect(Plan.prime_basic_subscription_count).to eq 0
    end

    it 'returns 1 when there is 1 active subscription to the Prime Basic plan' do
      plan = create_prime_basic_plan
      create_active_subscription_for(plan)

      expect(Plan.prime_basic_subscription_count).to eq 1
    end
  end

  describe '.prime_workshops_subscription_count' do
    it 'returns 0 when there are no active subscriptions to the Prime Workshops plan' do
      plan = create_prime_workshops_plan
      create_inactive_subscription_for(plan)

      expect(Plan.prime_workshops_subscription_count).to eq 0
    end

    it 'returns 1 when there is 1 active subscription to the Prime Workshops plan' do
      plan = create_prime_workshops_plan
      create_active_subscription_for(plan)

      expect(Plan.prime_workshops_subscription_count).to eq 1
    end
  end

  describe '.prime_with_mentoring_subscription_count' do
    it 'returns 0 when there are no active subscriptions to the Prime with Mentoring plan' do
      plan = create_prime_with_mentoring_plan
      create_inactive_subscription_for(plan)

      expect(Plan.prime_with_mentoring_subscription_count).to eq 0
    end

    it 'returns 1 when there is 1 active subscription to the Prime with Mentoring plan' do
      plan = create_prime_with_mentoring_plan
      create_active_subscription_for(plan)

      expect(Plan.prime_with_mentoring_subscription_count).to eq 1
    end
  end

  describe '#subscription_count' do
    it 'returns 0 when the plan has no subscriptions' do
      plan = create(:plan)
      expect(plan.subscription_count).to eq 0
    end

    it 'returns 1 when the plan has a single active subscription' do
      plan = create(:plan)
      create(:active_subscription, plan: plan)
      expect(plan.subscription_count).to eq 1
    end

    it 'returns 0 when the plan has only an inactive subscription' do
      plan = create(:plan)
      create_inactive_subscription_for(plan)
      expect(plan.subscription_count).to eq 0
    end
  end

  describe '#to_param' do
    it 'returns the sku' do
      plan = create(:plan)
      plan.to_param.should == "#{plan.sku}"
    end
  end

  describe 'purchase_for' do
    it 'returns the purchase when a user has purchased the plan' do
      create_mentors
      user = create(:user)
      purchase = create(:plan_purchase, user: user)
      plan = purchase.purchaseable

      expect(plan.purchase_for(user)).to eq purchase
    end

    it 'returns nil when a user has not purchased the plan' do
      create_mentors
      user = create(:user)
      purchase = create(:plan_purchase)
      plan = purchase.purchaseable

      expect(plan.purchase_for(user)).to be_nil
    end
  end

  describe 'starts_on' do
    it 'returns the given date' do
      plan = create(:plan)
      expect(plan.starts_on(Time.zone.today)).to eq Time.zone.today
    end
  end

  describe 'ends_on' do
    it 'returns the given date' do
      plan = create(:plan)
      expect(plan.ends_on(Time.zone.today)).to eq Time.zone.today
    end
  end

  describe 'subscription_interval' do
    it 'returns the interval from the stripe plan' do
      plan = build_stubbed(:plan)
      stripe_plan = stub(interval: 'year')
      Stripe::Plan.stubs(:retrieve).returns(stripe_plan)

      expect(plan.subscription_interval).to eq 'year'
      expect(Stripe::Plan).to have_received(:retrieve).with(plan.sku)
    end
  end

  describe 'offering_type' do
    it 'returns subscription' do
      plan = build_stubbed(:plan)

      result = plan.offering_type

      expect(result).to eq 'subscription'
    end
  end

  describe 'fulfillment_method' do
    it 'returns subscription' do
      plan = build_stubbed(:plan)

      result = plan.fulfillment_method

      expect(result).to eq 'subscription'
    end
  end

  describe '#alternates' do
    it 'is empty' do
      plan = Plan.new

      result = plan.alternates

      expect(result).to eq []
    end
  end

  describe '#announcement' do
    it 'calls Announcement.current' do
      Announcement.stubs :current
      plan = create(:plan)
      plan.announcement
      expect(Announcement).to have_received(:current)
    end
  end

  def create_prime_basic_plan
    create(:plan, sku: Plan::PRIME_BASIC_SKU)
  end

  def create_prime_workshops_plan
    create(:plan, sku: Plan::PRIME_WORKSHOPS_SKU)
  end

  def create_prime_with_mentoring_plan
    create(:plan, sku: Plan::PRIME_WITH_MENTORING_SKU)
  end

  def create_inactive_subscription_for(plan)
    create(:inactive_subscription, plan: plan)
  end

  def create_active_subscription_for(plan)
    create(:subscription, plan: plan)
  end

end
