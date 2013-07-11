require 'spec_helper'

feature 'Subscriber engagement' do
  scenario 'An admin views a user with 0 engagement' do
    visit_engagements_with_unengaged_user

    expect(page).to have_content('Subscriber Engagement Index')
    expect(engagement_score).to have_content('0')
  end

  scenario 'An admin views a user who has taken 3 workshops' do
    visit_engagements_with_user_taking_workshops 3

    expect(engagement_score).to have_content('80')
    expect(workshops_taken).to have_content('3')
    expect(last_workshop_taken_date).to have_content(Date.today.to_s)
  end

  def visit_engagements_with_unengaged_user
    visit_engagements
  end

  def visit_engagements_with_user_taking_workshops(taken_workshops)
    visit_engagements do |user|
      taken_workshops.times { create(:section_purchase, user: user) }
    end
  end

  def visit_engagements
    create(:discourse_oauth_application)
    user = create(:subscription).user
    yield user if block_given?
    visit subscriber_engagements_path
  end

  def engagement_score
    find('.engagement-score')
  end

  def workshops_taken
    find('.workshops-taken')
  end

  def last_workshop_taken_date
    find('.last-workshop-taken-date')
  end
end
