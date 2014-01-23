require 'spec_helper'

feature 'User views detail page' do
  scenario 'shows subscription time in months' do
    Timecop.freeze(Time.now) do
      subscription = create(:subscription, created_at: 1.month.ago)
      user = create(:user, subscription: subscription)

      visit subscriber_detail_path(user, as: user)

      expect(page).to have_content("subscribed 1 month")
    end
  end

end
