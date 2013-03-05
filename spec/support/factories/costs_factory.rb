FactoryGirl.define do
  factory :costs, class: 'Property::Costs' do 
    after :build do |costs|
      FactoryGirl.create :monthly_costs, rent: 1, costs: costs
    end
  
    trait :valid do
      after :build do |costs|
        FactoryGirl.create :valid_monthly_costs,  costs: costs
        FactoryGirl.create :valid_one_time_costs, costs: costs
      end
    end 

    factory :valid_costs, traits: [:valid] 
  end
end