class PurchaseAttributes
  def initialize(options)
    @params = options[:params]
    @user = options[:user]
  end

  def build
    permitted_params.merge(
      user: user,
      coupon: coupon,
      stripe_customer_id: existing_stripe_customer_id,
    )
  end

  private

  attr_reader :purchase, :params, :user

  def permitted_params
    params.require(:purchase).permit(:stripe_coupon_id, :variant,
      :name, :email, :password, { github_usernames: [] }, :organization,
      :address1, :address2, :city, :state, :zip_code, :country,
      :payment_method, :stripe_token, :mentor_id, :quantity)
  end

  def coupon
    Coupon.active.find_by(id: params[:coupon_id])
  end

  def existing_stripe_customer_id
    if user.present? && using_existing_card?
      user.stripe_customer_id
    end
  end

  def using_existing_card?
    params[:use_existing_card] == 'on'
  end
end
