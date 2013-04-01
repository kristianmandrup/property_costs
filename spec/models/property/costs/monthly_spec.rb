require 'spec_helper'

describe Property::Costs::Monthly do
  subject { property }

  def total_of costs
    Property::Costs::Monthly.cost_types.inject(0) do |sum, cost| 
      value = costs.send(cost) || 0
      sum += value
    end
  end

  context 'property with no costs' do
    let(:property)  { Property.create }
    let(:costs)     { property.costs  }

    before :all do
      # puts subject.to_s
    end

    it 'should have rent = 0' do
      expect(subject.rent).to eq 0
    end

    it 'should be valid without rent set > 0' do
      expect(subject.valid?).to be true
    end

    # it 'should set total monthly costs to 0' do
    it 'should raise error on calculating monthly total costs' do
      # expect(subject.monthly_cost).to eq total_of(costs)
      expect {costs.monthly.total}.to raise_error(Property::Costs::NoRentDefinedError)
    end

    it 'should set total monthly costs to 0' do    
      expect(subject.monthly_cost).to eq 0
    # it 'should raise error on calculating monthly costs' do
      # expect {subject.monthly_cost}.to raise_error(Property::Costs::NoRentDefinedError)
    end

    # it 'should set total rent to 0' do
    it 'should raise error on calculating total rent' do
      # expect(subject.total_rent).to eq 0
      expect(subject.total_rent).to eq 0
    end

    context 'set rent to 1800' do
      before do
        subject.costs.monthly.rent = 1800
        # puts subject.to_s
        @total_monthly = total_of(subject.costs.monthly)
      end

      it 'should be valid with rent > 0' do
        expect(subject.valid?).to be true
      end

      it 'should set total rent to 1800' do
        expect(subject.total_rent).to eq @total_monthly
      end

      it 'should set total monthly costs to 1800' do
        expect(subject.costs.monthly.total).to eq @total_monthly
      end
    end
  end

  context 'property with only utilities costs (100)' do
    let(:property)  { Property.create costs: {monthly: {rent: 0, utilities: 100 }}}
    let(:costs)     { property.costs }

    it 'should be valid without rent set > 0' do
      expect(subject.valid?).to be true
    end

    it 'should calc total monthly costs as 0' do    
      expect(subject.monthly_cost).to eq 0
    # it 'should raise error on calculating monthly costs' do  
      # expect {subject.monthly_cost}.to raise_error(Property::Costs::NoRentDefinedError)
    end

    it 'should calc total rent as 0' do
      expect(subject.total_rent).to eq 0
    # it 'should raise error on calculating total rent' do      
      # expect {subject.total_rent}.to raise_error(Property::Costs::NoRentDefinedError)
    end
  end

  context 'property with all monthly costs set (rent: 500, media: 200, utilities: 100, other: 50) = 850' do
    let(:property)  { create :valid_property }
    let(:costs)     { property.costs }

    context 'costs' do
      it 'should be valid with rent > 0' do
        expect(costs.valid?).to be true
      end

      it 'should have no errors' do
        expect(costs.errors).to be_empty
      end

      context 'monthly' do
        it 'should be valid with rent > 0' do
          expect(costs.monthly.valid?).to be true
        end

        it 'should have no errors' do
          expect(costs.monthly.errors).to be_empty
        end
      end

      context 'one time' do
        it 'should be valid with rent > 0' do
          expect(costs.one_time.valid?).to be true
        end

        it 'should have no errors' do
          expect(costs.one_time.errors).to be_empty
        end
      end
    end

    it 'should be valid with rent > 0' do
      expect(subject.valid?).to be true
    end

    it 'should have no errors' do
      expect(subject.errors).to be_empty
    end

    ::Property::Costs::Monthly.cost_types.each do |type|
      it "should set #{type}" do
        expect(subject.costs.send type).to be >= 0
      end
    end

    it 'should set total rent to 850' do
      expect(subject.total_rent).to eq total_of(costs)
    end

    it 'should set total monthly costs to 850' do
      expect(subject.monthly_cost).to eq total_of(costs)
    end
  end
end