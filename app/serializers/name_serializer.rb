class NameSerializer < ActiveModel::Serializer
  attributes :name, :gender
  def id
    object.slug
  end
end
