Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "add_tab_to_admin_menu",
                     :insert_top => "#main-sidebar",
                     :partial => "spree/admin/shared/recurring_orders_tab",
                     :disabled => false)
