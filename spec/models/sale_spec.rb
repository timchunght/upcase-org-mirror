require 'spec_helper'

describe Sale do
  it 'creates the given purchase with the given params' do
    purchase = build(:purchase)

    Sale.new(purchase: purchase,
             params: purchase_params(purchase: { name: 'New Name' }))
      .complete

    expect(purchase.name).to eq('New Name')
    expect(purchase).to be_persisted
  end

  it 'sets the coupon if one is present' do
    coupon = create(:coupon, active: true)
    purchase = build(:purchase)

    Sale.new(purchase: purchase,
             params: purchase_params(coupon_id: coupon.id))
      .complete

    expect(purchase.coupon).to eq(coupon)
  end

  it 'does not set a coupon if no coupon id is present' do
    coupon = create(:coupon, active: true)
    purchase = build(:purchase)

    Sale.new(purchase: purchase, params: purchase_params).complete

    expect(purchase.coupon).to be_nil
  end

  it 'sets the user if the user is present' do
    user = create(:user)
    purchase = build(:purchase)

    Sale.new(purchase: purchase, params: purchase_params, user: user).complete

    expect(purchase.user).to eq(user)
  end

  it "sets the stripe id if user is present and we're using an existing card" do
    user = create(:user, stripe_customer_id: 'anything')
    purchase = build(:purchase)

    Sale.new(purchase: purchase,
             params: purchase_params(use_existing_card: 'on'),
             user: user)
      .complete

    expect(purchase.stripe_customer_id).to eq('anything')
  end

  it 'does not set the stripe id if there is no user' do
    purchase = build(:purchase, payment_method: 'free')

    Sale.new(purchase: purchase,
             params: purchase_params(use_existing_card: 'on'))
      .complete

    expect(purchase.stripe_customer_id).to be_nil
  end

  it 'does not set the stripe id if we are not using an existing card' do
    purchase = build(:purchase, payment_method: 'free')
    user = create(:user, stripe_customer_id: 'cus12345')

    Sale.new(purchase: purchase,
             params: purchase_params(use_existing_card: 'off'),
             user: user)
      .complete

    expect(purchase.stripe_customer_id).to be_nil
  end

  def purchase_params(params = {})
    params[:purchase] ||= { name: 'anything' }
    ActionController::Parameters.new(params)
  end
end
