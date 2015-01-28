require 'spec_helper'

describe Spree::Admin::RecurringEmailsController do

  let(:user) { double Spree::User, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'fake' }

  before :each do
    controller.stub :spree_current_user => user
    controller.stub :check_authorization
  end

  describe 'create' do

    let(:order){ Spree::Order.new }

    before :each do
      order.stub(:number).and_return("G1234")
      order.stub(:id).and_return("1")
      Spree::Order.stub(:find_by).and_return(order)
    end

    it 'should send email' do
      Spree::Order.should_receive(:find_by).with(number: "G1234").and_return(order)
      order.should_receive(:deliver_recurring_order_email)

      spree_post :create, { number: 'G1234' }
    end

    it 'should redirect order page' do
      spree_post :create, { number: 'G1234' }
      response.should redirect_to('/admin/orders/G1234/edit')
    end

  end

end
