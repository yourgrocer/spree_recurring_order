Spree::User.class_eval do
  has_one :base_list, class_name: "Spree::RecurringList"
end
