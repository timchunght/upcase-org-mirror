class User < ActiveRecord::Base
  include Clearance::User

  has_many :licenses
  has_many :completions
  has_many :public_keys, dependent: :destroy
  has_one :purchased_subscription, dependent: :destroy, class_name: 'Subscription'
  belongs_to :mentor
  belongs_to :team

  validates :name, presence: true
  validates :mentor_id, presence: true, if: :has_subscription_with_mentor?

  delegate :email, to: :mentor, prefix: true, allow_nil: true
  delegate :first_name, to: :mentor, prefix: true, allow_nil: true
  delegate :name, to: :mentor, prefix: true, allow_nil: true
  delegate :plan, to: :subscription, allow_nil: true

  def self.with_active_subscription
    includes(purchased_subscription: :plan, team: { subscription: :plan }).
      select(&:has_active_subscription?)
  end

  def first_name
    name.split(" ").first
  end

  def last_name
    name.split(' ').drop(1).join(' ')
  end

  def external_auth?
    auth_provider.present?
  end

  def has_licensed?
    licenses.present?
  end

  def inactive_subscription
    if has_active_subscription?
      nil
    else
      most_recently_deactivated_subscription
    end
  end

  def has_logged_in_to_forum?
    OauthAccessToken.for_user(self).present?
  end

  def has_active_subscription?
    subscription.present?
  end

  def has_access_to?(feature)
    subscription.present? && subscription.has_access_to?(feature)
  end

  def subscribed_at
    subscription.try(:created_at)
  end

  def credit_card
    if stripe_customer
      stripe_customer['active_card']
    end
  end

  def assign_mentor(mentor)
    update(mentor: mentor)
  end

  def has_subscription_with_mentor?
    has_access_to?(:mentor)
  end

  def plan_name
    plan.try(:name)
  end

  def subscription
    [purchased_subscription, team_subscription].compact.detect(&:active?)
  end

  def annualized_payment
    plan.annualized_payment
  end

  def discounted_annual_payment
    plan.discounted_annual_payment
  end

  private

  def team_subscription
    if team.present?
      team.subscription
    end
  end

  def stripe_customer
    if stripe_customer_id.present?
      Stripe::Customer.retrieve(stripe_customer_id)
    end
  end

  def password_optional?
    super || external_auth?
  end

  def most_recently_deactivated_subscription
    [purchased_subscription, team_subscription].
      compact.
      reject(&:active?).
      max_by(&:deactivated_on)
  end
end
