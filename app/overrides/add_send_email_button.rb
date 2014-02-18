Deface::Override.new(:virtual_path => "spree/admin/shared/_content_header",
                     :name => "add_send_email_button",
                     :insert_top => "[data-hook='toolbar']>ul",
                     :partial => "spree/admin/orders/send_recurring_email_button",
                     :disabled => false)
