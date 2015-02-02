Deface::Override.new(:virtual_path => "spree/shared/_products",
                     :name => "add_message_to_checkout",
                     :insert_bottom => "[data-hook='products_list_item']",
                     :partial => "spree/shared/regular_add_cart_button",
                     :sequence => {:after => "quick_cart_add_button"},
                     :disabled => false)
