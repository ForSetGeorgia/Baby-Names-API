class NameYearsSerializer < ActiveModel::Serializer
  attributes :id, :name, :gender

  def id
    "#{object.slug}"
  end

  has_many :years
end
