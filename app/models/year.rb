class Year < ApplicationRecord
  ##################
  ## ASSOCIATIONS
  ##################
  belongs_to :name

  ##################
  ## VALIDATIONS
  ##################
  validates_presence_of :year

  ##################
  ## SCOPES
  ##################
  def self.unique
    select('year').distinct.pluck(:year).uniq.sort
  end
end
