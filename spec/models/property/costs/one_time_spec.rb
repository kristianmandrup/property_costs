require 'spec_helper'

describe Property::Costs::OneTime do
  subject { property }

  def total_of costs
    Property::Costs::OneTime.cost_types.inject(0) do |sum, cost| 
      value = costs.send(cost) || 0
      sum += value
    end
  end

  context 'property with no costs' do
    let(:property)  { Property.create }
    let(:costs)     { property.costs  }

    it 'should set total rent to 0' do
      expect(subject.total_rent).to eq total_of(costs)
    end

    it 'should set total one time costs to 0' do
      expect(subject.one_time_cost).to eq total_of(costs)
    end

    context 'set deposit to 1800' do
      before do
        subject.costs.one_time.deposit = 1800
        @total = total_of(subject.costs.one_time)
      end

      it 'should set total rent to 0' do
        expect(subject.total_rent).to eq 0
      end

      it 'should set entrance costs rent to 1800' do
        expect(subject.total_entrance_cost).to eq @total
      end

      it 'should set one_time cost to 1800' do
        expect(subject.costs.one_time.cost).to eq @total
      end

      it 'should set total one_time costs to 1800' do
        expect(subject.costs.one_time.total).to eq @total
      end
    end
  end

  context 'property with only prepaid_rent (100)' do
    let(:property)  { Property.create costs: {one_time: {deposit: nil, prepaid_rent: 100 }}}
    let(:costs)     { property.costs }

    it 'should set total rent to 0' do
      expect(subject.total_rent).to eq 0
    end

    it 'should set total one time costs to 100' do
      expect(subject.one_time_cost).to eq total_of(costs)
    end
  end

  context 'property with all one time costs set (deposit: 1000, prepaid_rent: 500) = 1500' do
    let(:property)  { Property.create costs: {one_time: {deposit: 1000, prepaid_rent: 500}}}
    let(:costs)     { property.costs }

    ::Property::Costs::OneTime.cost_types.each do |type|
      it "should set #{type}" do
        expect(subject.costs.send type).to be > 0
      end
    end

    it 'should set total entrance cost to 1500' do
      expect(subject.total_entrance_cost).to eq total_of(costs)
    end

    it 'should set total one time costs to 1500' do
      expect(subject.one_time_cost).to eq total_of(costs)
    end
  end
end