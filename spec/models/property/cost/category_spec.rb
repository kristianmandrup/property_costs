require 'spec_helper'

describe Property::Cost::Category do
  subject { clazz.new property, label }
  
  let(:label)     { 'Monthly'}
  let(:clazz)     { Property::Cost::Category }
  let(:property)  { create :valid_property }

  specify { subject.cost_items.should_not be_empty }  
end