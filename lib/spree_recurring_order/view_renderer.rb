module ViewRenderer

  def self.render options = {}
    assigns = options.delete(:assigns) || {} 
    view = view_class.new ActionController::Base.view_paths, assigns
    view.render options
  end

  def self.view_class
    @view_class ||= Class.new ActionView::Base do
      # include Rails.application.routes.url_helpers
    end
  end
end
