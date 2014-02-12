Spree::Order.class_eval do

  belongs_to :recurring_order

  def recurring?
    !recurring_order.nil?
  end

end
