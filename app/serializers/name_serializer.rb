class NameSerializer
  include FastJsonapi::ObjectSerializer
  set_id :slug
  attributes :name, :gender
end
