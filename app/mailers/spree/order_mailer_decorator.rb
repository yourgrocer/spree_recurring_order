Spree::OrderMailer.class_eval do

  def recurring_email(order_id)
    #do nothing - this should be overridden
  end

  def recurring_induction_email(recurring_order_id)
    #do nothing - this should be overridden
  end

end
