module Spree
  class RecurringOrderProcessingMailer < ::MandrillMailer::MessageMailer
    def render_template(view_path, data = {})
      ::ViewRenderer.render template: "#{view_path}", assigns: data
    end

    def results_email(results, date)
      view_data = {results: results, date: date } 
      mandrill_mail subject: "Recurring orders processing report for #{date.strftime('%B %d, %Y')}",
        to: 'hello@yourgrocer.com.au', 
        template_name: 'recurring_orders_report',
        from: 'hello@yourgrocer.com.au',
        from_name: 'YourGrocer Website',
        vars: {},
        html: render_template('spree/recurring_order_processing_mailer/processing_report', view_data)
    end
  end
end
