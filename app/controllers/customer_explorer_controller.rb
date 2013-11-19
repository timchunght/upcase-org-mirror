class CustomerExplorerController < ApplicationController

  layout 'empty-body'

  def index
    @churned_customers = Subscription.where('deactivated_on is not NULL').where('user_id is not NULL').
      order('deactivated_on desc').limit(100).includes(:user)
  end
end
