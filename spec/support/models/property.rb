class Property
  include Mongoid::Document

  def to_s
    %Q{
id: #{id}
costs: #{costs if costs}
}
  end
end
