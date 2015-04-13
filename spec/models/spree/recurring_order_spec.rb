require 'spec_helper'

describe Spree::RecurringOrder do

  describe 'active' do

    it 'should be active by default' do
      recurring_order = Spree::RecurringOrder.new
      expect(recurring_order.active).to be_truthy
    end

  end

  describe 'create order from base list' do

    let(:new_order){double(Spree::Order).as_null_object}
    let(:normal_user){FactoryGirl.create(:user, email: 'test@email.com')}
    let(:order_contents){double(Spree::OrderContents).as_null_object}
    let(:item){FactoryGirl.build(:recurring_list_item)}
    let(:base_list){Spree::RecurringList.new}
    let(:recurring_order){Spree::RecurringOrder.new}

    before :each do
      address = FactoryGirl.create(:address)
      old_order = FactoryGirl.create(:order, user: normal_user, state: 'complete', completed_at: Time.now, ship_address: address, bill_address: address)
      normal_user.orders << old_order

      allow(Spree::Order).to receive(:new).and_return(new_order)
      allow(Spree::OrderContents).to receive(:new).and_return(order_contents)

      @recurring_order = Spree::RecurringOrder.new
      @base_list = Spree::RecurringList.new(next_delivery_date: Date.tomorrow)
      @base_list.user = normal_user
      @base_list.items << item
      @recurring_order.recurring_lists << @base_list
    end

    it 'should set email and created by' do
      expect(new_order).to receive(:email=).with('test@email.com')
      expect(new_order).to receive(:created_by=).with(normal_user)

      @recurring_order.create_order_from_base_list
    end

    it 'should merge with cart order if user has one' do
      incomplete_order = double(Spree::Order, id: 1234, number: 'A1234', delivery_date: nil).as_null_object
      allow(normal_user).to receive(:last_incomplete_spree_order).and_return incomplete_order
      expect(new_order).to receive(:merge!).with(incomplete_order)

      @recurring_order.create_order_from_base_list
    end


    it 'should update next_delivery_date for recurring order' do
      expect(@base_list).to receive(:update_next_delivery_date!)
      @recurring_order.create_order_from_base_list
    end

    it 'should add items from base list' do
      expect(order_contents).to receive(:add).with(item.variant, item.quantity, anything)
      @recurring_order.create_order_from_base_list
    end
  end

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
