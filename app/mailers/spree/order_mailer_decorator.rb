Spree::OrderMailer.class_eval do

  def recurring_email(order_id)
    #do nothing - this should be overriden
  end

end
