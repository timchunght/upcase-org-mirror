class CouponsController < ApplicationController
  def show
    if @coupon = find_coupon(params[:id])
      session[:coupon_id] = @coupon.id
    elsif @coupon = find_subscription_coupon(params[:id])
      session[:stripe_coupon_id] = params[:id]
    end
  end

  private

  def find_coupon(code)
    Coupon.where(code: code).first
  end

  def find_subscription_coupon(code)
    SubscriptionCoupon.new(code)
  end
end
