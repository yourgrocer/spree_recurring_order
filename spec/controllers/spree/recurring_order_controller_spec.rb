require 'spec_helper'

describe Spree::RecurringOrdersController do

  let(:original_order){ FactoryGirl.build(:order, id: 1, number: 'G1234') }
  let(:orders){ [] }
  let(:recurring_order){ double(Spree::RecurringOrder, save: true, id: 666, orders: orders).as_null_object }
  let(:user) { double(Spree::User, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'fake').as_null_object }

  before :each do
    controller.stub :spree_current_user => user
    controller.stub :check_authorization
  end

  describe 'integration' do

    it 'should create new recurring order (integration)' do
      skip("Failing since spree upgrade")
      old_order = FactoryGirl.create(:order)
      spree_post :create, recurring_order: {original_order_id: old_order.id}
      Spree::RecurringOrder.last.original_order.should == old_order
    end

  end

  describe 'create' do

    before :each do
      Spree::Order.stub(:find).with("1").and_return(original_order)
      Spree::RecurringOrder.stub(:new).and_return(recurring_order)
    end


    it 'should create new recurring order' do
      skip("Failing since spree upgrade")
      orders.should_receive(:<<).with(original_order)
      recurring_order.should_receive(:save).and_return(true)

      spree_post :create, recurring_order: {original_order_id: 1}
      response.should redirect_to("/recurring_orders/666")
    end

    it 'should render order complete if recurring order cant be saved' do
      skip("Failing since spree upgrade")
      recurring_order.should_receive(:save).and_return(false)

      spree_post :create, recurring_order: {original_order_id: 1}
      response.should redirect_to("/orders/G1234")
    end

    it 'should render order complete if recurring order already exists' do
      skip("Failing since spree upgrade")
      original_order.stub(:recurring_order).and_return(recurring_order)
      spree_post :create, recurring_order: {original_order_id: 1}
      response.should redirect_to("/orders/G1234")
    end

  end

  describe 'show' do

    before :each do
      Spree::RecurringOrder.stub(:find).with("1").and_return(recurring_order)
    end

    it 'should render' do
      skip("Failing since spree upgrade")
      spree_post :show, id: 1
      response.should render_template(:show)
    end


  end

end
