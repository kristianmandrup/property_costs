require 'spec_helper'

describe Property::RentCost do
  subject { property }

  def total_of costs, type = :one_time
    clazz = "Property::Costs::#{type.to_s.camelize}".constantize
    clazz.cost_types.inject(0) do |sum, cost| 
      value = costs.send(cost) || 0
      sum += value
    end
  end
  alias_method :total_for, :total_of

  context 'default' do

    let(:property) { create :property, cost: 0 }

    let(:costs)    { property.costs }
    let(:one_time) { property.costs.one_time }
    let(:monthly)  { property.costs.monthly }

    # before :each do
    #   puts "property: #{subject}"
    # end

    it 'should have rent > 0' do
      expect(subject.rent).to be >= 0
    end

    it 'should be valid with rent > 0' do
      expect(subject.valid?).to be true
    end

    describe 'costs' do
      subject { costs }

      it 'should sum total rent correctly' do
        expect(subject.total_rent).to eq total_of(monthly, :monthly)
      end

      it 'should sum one time cost correctly' do
        expect(subject.one_time_cost).to eq total_of(one_time, :one_time)
      end

      it 'should sum initial_payment as one time cost + monthly total' do
        expect(subject.initial_payment).to eq(one_time.total + monthly.total)
      end

      it 'should alias initial payment as entrance cost' do
        expect(subject.entrance_cost).to eq(subject.initial_payment)
      end
    end
  end

  context 'valid' do
    let(:property) { create :property }
    let(:costs)    { property.costs }    

    # before :each do
    #   puts "property: #{subject}"
    # end

    describe 'property' do
      subject { costs }

      it 'should set deposit to 2 x total rent by default' do
        expect(subject.deposit).to eq(costs.total_rent * 2)
      end

      it 'should set prepaid rent to equal total rent by default' do
        expect(subject.prepaid_rent).to eq costs.total_rent
      end

      context 'set rent to 2000' do
        before do
          subject.rent = 2000
        end

        it 'should set deposit to 2 x total rent by default' do
          # pending 'decision ?'
          expect(subject.deposit).to eq(costs.total_rent * 2)
        end

        it 'should set prepaid rent to equal total rent by default' do
          # pending 'decision ?'
          expect(subject.prepaid_rent).to eq costs.total_rent
        end
      end        
    end
  end
end