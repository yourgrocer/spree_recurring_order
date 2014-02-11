require 'spec_helper'

describe Spree::OrdersController do

  let(:order) {double(Spree::Order)}
  let(:recurring_order) {double(Spree::RecurringOrder)}
  let(:user) { mock_model Spree::User, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'fake' }

  before :each do
    controller.stub :spree_current_user => user
    controller.stub :check_authorization
  end


  describe 'show' do

    before :each do
      Spree::Order.stub(:find_by_number!).with("G2134").and_return(order)
      Spree::RecurringOrder.stub(:new).and_return(recurring_order)
    end

    it 'should assign order' do
      spree_get :show, id: "G2134"
      assigns(:order).should == order
    end

    it 'should assign recurring order' do
      spree_get :show, id: "G2134"
      assigns(:recurring_order).should == recurring_order
    end

    it 'should render show_recurring if order completed is true' do
      spree_get :show, {id: "G2134", order_completed: true}
      assigns(:present_recurring).should == true 
      response.should render_template('show_recurring')
    end

    it 'should render show normally' do
      spree_get :show, {id: "G2134"}
      assigns(:present_recurring).should == false
      response.should render_template('show')
    end

  end

end
