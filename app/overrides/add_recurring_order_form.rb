Deface::Override.new(:virtual_path => "spree/orders/show",
                     :name => "add_recurring_order_form",
                     :insert_before => "#order_summary",
                     :partial => "spree/orders/recurring_order_form",
                     :disabled => false)
