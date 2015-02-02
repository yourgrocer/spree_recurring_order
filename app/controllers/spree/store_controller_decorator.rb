Spree::StoreController.class_eval do

  after_filter :add_base_list_id_to_cookies, only: [:show, :index]

  private

  def add_base_list_id_to_cookies
    user = try_spree_current_user
    if user && user.base_list
      cookies[:base_list_id] = user.base_list.id
    end
  end

end
