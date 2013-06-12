class ContributionsController < BaseController
  def callback
    @identifier_id = (params[:identifier_id])
    @response_code = (params[:response_code])
    @contribution = Contribution.new(:identifier_id => @identifier_id, :response_code => @response_code)
    @contribution.user = current_user
    @contribution.save!
    redirect_to @contribution
  end

  def show
  end

  def create
    amount = params[:amount]
    currency = params[:currency]
    wrapper = SwipeWrapper.new
    identifier = wrapper.create_tx_identifier_for(user: current_user, amount: amount, currency: currency)
    redirect_to "https://payment.swipehq.com/?identifier_id=#{identifier}"
  end
end
