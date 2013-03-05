class Property
  include Mongoid::Document

  include_concerns  :rent_cost

  field :name
end