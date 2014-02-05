Deface::Override.new(:virtual_path => "spree/admin/shared/_menu",
                     :name => "add_tab_to_admin_menu",
                     :insert_top => "[data-hook='admin_tabs']",
                     :partial => "spree/admin/shared/recurring_orders_tab",
                     :disabled => false)
