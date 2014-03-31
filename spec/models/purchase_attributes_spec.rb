require 'spec_helper'

describe PurchaseAttributes do
  describe '#build' do
    it 'sets the coupon if one is present' do
      coupon = create(:coupon, active: true)

      attributes = PurchaseAttributes.new(params: purchase_params(coupon_id: coupon.id))
      .build

      expect(attributes[:coupon]).to eq(coupon)
    end

    it 'sets the user if the user is present' do
      user = create(:user)

      attributes =
        PurchaseAttributes.new(params: purchase_params, user: user).build

      expect(attributes[:user]).to eq(user)
    end

    it "sets the stripe id if user is present and we're using an existing card" do
      user = create(:user, stripe_customer_id: 'anything')

      attributes =
        PurchaseAttributes
          .new(params: purchase_params(use_existing_card: 'on'),
               user: user)
          .build

      expect(attributes[:stripe_customer_id]).to eq('anything')
    end

    it 'does not set the stripe id if there is no user' do
      purchase = build(:purchase, payment_method: 'free')

      attributes =
        PurchaseAttributes.new(params: purchase_params(use_existing_card: 'on'))
        .build

      expect(attributes[:stripe_customer_id]).to be_nil
    end

    it 'does not set the stripe id if we are not using an existing card' do
      user = create(:user, stripe_customer_id: 'cus12345')

      attributes =
        PurchaseAttributes
          .new(params: purchase_params(use_existing_card: 'off'),
               user: user)
          .build

      expect(attributes[:stripe_customer_id]).to be_nil
    end

    def purchase_params(params = {})
      params[:purchase] ||= { name: 'anything' }
      ActionController::Parameters.new(params)
    end
  end
end
