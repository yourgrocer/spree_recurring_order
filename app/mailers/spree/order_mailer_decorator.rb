Spree::OrderMailer.class_eval do

  def recurring_email(order_id)
    #do nothing - this should be overriden
  end

  def recurring_orders_processing_email(results)

  end

end
