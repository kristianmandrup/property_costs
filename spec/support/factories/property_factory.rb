FactoryGirl.define do
  factory :property, class: 'Property' do
    after :build do |property|
      FactoryGirl.create :costs, property: property
    end      
    
    trait :valid do
      after :build do |property|
        FactoryGirl.create :valid_costs, property: property
      end      
    end

    factory :valid_property, traits: [:valid] 
  end
end