FactoryGirl.define do
  sequence(:rent)         { [1,2,2,2,3,3,4,5].sample * 1000 }
  sequence(:utilities)    { (rand(8) +1) * 100 }
  sequence(:media)        { (rand(8) +1) * 100 }
  sequence(:other)        { (rand(3)+1) * 100  }

  factory :monthly_costs, class: 'Property::Costs::Monthly', :aliases => [:monthly] do
    trait :valid do
      rent
      utilities
      media
      other
    end 

    factory :valid_monthly_costs, traits: [:valid]   
  end
end