# Calculates metrics to measure a subscriber's engagement with Prime.
class SubscriberEngagement
  def initialize(user)
    @user = user
  end

  def engagement_score
    total = 0

    if user_has_logged_in_to_forum?
      total += 20
    end

    if user_has_claimed_product_in_last_30_days?
      total += 20
    end

    if user_enrolled_in_workshop_in_last_30_days?
      total += 40
    end

    if user_has_taken_many_workshops?
      total += 20
    end

    total
  end

  def count_of_workshops_taken
    purchases.of_sections.count
  end

  def date_of_last_workshop_claim
    purchases.date_of_last_workshop_purchase
  end

  def name
    @user.name
  end

  def email
    @user.email
  end

  private

  def user_has_logged_in_to_forum?
    AccessTokenQuery.new(Doorkeeper::AccessToken).for_discourse.for_user(@user)
  end

  def user_enrolled_in_workshop_in_last_30_days?
    purchases.of_sections.within_30_days.present?
  end

  def user_has_claimed_product_in_last_30_days?
    purchases.within_30_days.present?
  end

  def user_has_taken_many_workshops?
    purchases.of_sections.count > 2
  end

  def purchases
    @user.purchases
  end
end
