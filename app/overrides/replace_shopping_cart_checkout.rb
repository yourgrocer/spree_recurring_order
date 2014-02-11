Deface::Override.new(:virtual_path => "spree/orders/edit",
                     :name => "remove_shopping_cart_checkout",
                     :replace => "[data-hook='cart_buttons']",
                     :partial => "spree/orders/cart_buttons",
                     :disabled => false)
