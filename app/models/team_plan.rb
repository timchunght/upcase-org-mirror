# TeamPlans represent a purchase of a Plan for an entire team.
# Because they are rare, they are created manually in a console, not the UI.
class TeamPlan < ActiveRecord::Base
  has_many :subscriptions, as: :plan
  has_many :purchases, as: :purchaseable

  validates :sku, presence: true
  validates :name, presence: true
  validates :price, presence: true
end
