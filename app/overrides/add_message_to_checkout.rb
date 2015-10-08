Deface::Override.new(:virtual_path => "spree/orders/edit",
                     :name => "add_message_to_checkout",
                     :insert_before => "[data-hook='outside_cart_form']",
                     :partial => "spree/orders/recurring_message",
                     :disabled => true)
