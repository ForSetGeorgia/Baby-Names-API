class Name < ApplicationRecord
  ##################
  ## ASSOCIATIONS
  ##################
  has_many :years, dependent: :destroy

  ##################
  ## VALIDATIONS
  ##################
  validates_presence_of :name_ka, :name_en
  validates_inclusion_of :gender, in: ['m', 'f']

  ##################
  ## SCOPES
  ##################
  def self.search(q=nil)
    if q.nil?
      return Name.none
    else
      return where("name_en LIKE ?", "%#{q}%")
    end
  end

end
