require 'spec_helper'

describe Spree::RecurringOrdersController do
  
  let(:original_order){ FactoryGirl.build(:order) }
  let(:recurring_order){ double(Spree::RecurringOrder, save: true, id: 666) }
  let(:user) { mock_model Spree::User, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'fake' }

  before :each do
    controller.stub :spree_current_user => user
  end

  describe 'create' do

    it 'should create new recurring order' do
      controller.stub :check_authorization

      Spree::Order.stub(:find).with("1").and_return(original_order)
      Spree::RecurringOrder.stub(:new).and_return(recurring_order)

      recurring_order.should_receive(:original_order=).with(original_order)

      spree_post :create, original_order_id: 1
      response.should redirect_to("/recurring_orders/666")
    end

  end

  describe 'show' do

    it 'should render'

  end

end
