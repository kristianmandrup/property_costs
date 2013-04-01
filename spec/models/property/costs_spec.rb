require 'spec_helper'

describe Property::Costs do
  subject { property }

  def total_of costs, type = :one_time
    clazz = "Property::Costs::#{type.to_s.camelize}".constantize
    clazz.cost_types.inject(0) do |sum, cost| 
      value = costs.send(cost) || 0
      sum += value
    end
  end

  context 'property with no costs' do
    let(:property)  { create :property }
    let(:costs)     { property.costs  }

    it 'should have rent = 0' do
      expect(subject.rent).to eq 0
    end

    it 'should be valid without rent > 0' do
      expect(subject.valid?).to be true
    end

    it 'should set total rent to 0' do
      expect(subject.total_rent).to eq total_of(costs)
    end

    context 'set deposit to 1000' do
      before do
        subject.costs.one_time.deposit = 1000
        @total_one_time = total_of(subject.costs.one_time, :one_time)
      end

      it 'should set total rent to 0' do
        expect(subject.total_rent).to eq 0
      end

      it 'should set entrance costs rent to 1000' do
        expect(subject.total_entrance_cost).to eq @total_one_time
      end

      it 'should set total one_time costs to 1000' do
        expect(subject.costs.one_time.total).to eq @total_one_time
      end

      context 'set rent to 1800' do
        before do
          subject.costs.monthly.rent = 1800
          @total_monthly = total_of(subject.costs.monthly, :monthly)
          @total_one_time = total_of(subject.costs.one_time, :one_time)

          # puts subject.to_s
        end

        it 'should set total rent to 1800' do
          expect(subject.total_rent).to eq @total_monthly
        end

        it 'should set total monthly costs to 1800' do
          expect(subject.costs.monthly.total).to eq @total_monthly
        end

        it 'should set entrance costs rent to 1000 + 1800 = 2800' do
          expect(subject.total_entrance_cost).to eq(@total_one_time + @total_monthly)
        end
      end
    end
  end
end