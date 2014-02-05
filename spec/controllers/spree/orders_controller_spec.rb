require 'spec_helper'

describe Spree::OrdersController do

  let(:order) {double(Spree::Order)}
  let(:user) { mock_model Spree::User, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'fake' }

  before :each do
    controller.stub :spree_current_user => user
    controller.stub :check_authorization
  end


  describe 'show' do

    before :each do
      Spree::Order.stub(:find_by_number!).with("G2134").and_return(order)
    end

    it 'should assign order' do
      spree_get :show, id: "G2134"
      assigns(:order).should == order
    end

  end

end
