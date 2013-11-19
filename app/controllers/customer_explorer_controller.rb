class CustomerExplorerController < ApplicationController

  layout 'empty-body'

  def index
    @churned_customers = Subscription.where('deactivated_on is not NULL').order('deactivated_on desc').limit(200).includes(:user)
  end
end
