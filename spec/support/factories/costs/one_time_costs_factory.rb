FactoryGirl.define do
  sequence(:deposit)        { [1,2,2,2,3,3,4,5].sample * 1000 }
  sequence(:prepaid_rent)   { [1,2,2,2,3,3,4,5].sample * 1000 }

  factory :one_time_costs, class: 'Property::Costs::OneTime', :aliases => [:one_time] do  
    trait :valid do
      deposit
      prepaid_rent      
    end 

    factory :valid_one_time_costs, traits: [:valid]   
  end
end