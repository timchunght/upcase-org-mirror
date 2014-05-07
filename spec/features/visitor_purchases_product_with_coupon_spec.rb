require 'spec_helper'

feature 'Using coupons' do
  include StripeHelpers
  include PurchaseHelpers

  scenario 'Visitor purchases screencast with a valid coupon', js: true do
    product = create(:screencast)
    create(:coupon, code: 'CODE', discount_type: 'percentage', amount: 10)

    visit coupon_path(coupon)
    expect(page).to contain('10% off')

    visit screencast_path(product)
    click_purchase_link_for(product)

    expect_submit_button_to_contain('10% off')

    pay_using_stripe

    expect_to_have_purchased(product)
  end

  scenario 'Visitor purchases a screencast with a 100%-off coupon', js: true do
    product = create(:screencast)
    create(:coupon, code: 'CODE', discount_type: 'percentage', amount: 100)

    visit coupon_path(coupon)
    expect(page).to contain('100% off')

    visit screencast_path(product)
    click_purchase_link_for(product)

    expect_payment_options_to_be_hidden

    fill_in 'Name', with: 'Eugene'
    fill_in 'Email', with: 'mr.the.plague@example.com'
    click_button 'Submit Payment'

    expect_to_have_purchased(product, 'mr.the.plague@example.com')
  end

  def expect_payment_options_to_be_hidden
    page.should have_no_css('#billing-information')
  end
end
