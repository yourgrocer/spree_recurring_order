require 'spec_helper'

describe Spree::RecurringOrder do

  describe 'create from order' do

    it 'should create from original order' do
      order = FactoryGirl.create(:order)

      recurring_order = Spree::RecurringOrder.create_from_order(order)
      recurring_order.id.should_not be_nil
    end

    it 'should set original order' do
      order = FactoryGirl.create(:order)

      recurring_order = Spree::RecurringOrder.create_from_order(order)
      recurring_order.original_order.should == order
    end

    it "should assign number that starts with R" do
      order = FactoryGirl.create(:order)

      recurring_order = Spree::RecurringOrder.create_from_order(order)
      recurring_order.number.should =~ /^R/
    end

    it "should assign number that has 6 numbers" do
      order = FactoryGirl.create(:order)

      recurring_order = Spree::RecurringOrder.create_from_order(order)
      recurring_order.number.should =~ /\d{6}$/
    end

  end


  describe 'validation' do

    it 'should not be valid without an order or recurring list' do
      recurring_order = Spree::RecurringOrder.new
      recurring_order.should_not be_valid
      recurring_order.errors[:base].should_not be_empty
    end

    it 'should be valid with a recurring list' do
      list = FactoryGirl.create(:recurring_list)

      recurring_order = Spree::RecurringOrder.new
      recurring_order.recurring_lists << list
      expect(recurring_order).to be_valid
    end

    it 'should be valid with one order' do
      order = FactoryGirl.build(:order)
      recurring_order = Spree::RecurringOrder.new
      recurring_order.orders << order
      recurring_order.should be_valid
    end

  end

  describe 'delegation' do

    let(:ship_address){FactoryGirl.build(:address)}
    let(:order){FactoryGirl.build(:order, ship_address: ship_address)}

    context 'with original order' do

      before :each do
        @recurring_order = Spree::RecurringOrder.new
        @recurring_order.orders << order
      end

      it 'should delegate customer email to original order' do
        @recurring_order.email.should == order.email
      end


      it 'should delegate customer phone to original order' do
        @recurring_order.phone.should == order.ship_address.phone
      end

    end

    context 'with recurring list' do

      before :each do
        @recurring_order = Spree::RecurringOrder.new
        @user = FactoryGirl.build(:user, email: 'test@email.com')
        @recurring_list = FactoryGirl.build(:recurring_list, user: @user)
        @recurring_order.recurring_lists << @recurring_list
      end

      it 'should delegate customer email to recurring list user' do
        @recurring_order.email.should == @user.email
      end

      it 'should be NA if there is no original order' do
        @recurring_order.phone.should == 'N/A' 
      end

    end

  end

end
