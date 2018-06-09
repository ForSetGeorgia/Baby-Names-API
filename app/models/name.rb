class Name < ApplicationRecord
  ##################
  ## ASSOCIATIONS
  ##################
  has_many :years, dependent: :destroy

  ##################
  ## VALIDATIONS
  ##################
  validates_presence_of :name_ka, :name_en

end
