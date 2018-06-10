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
  ## URL SLUGS
  ##################
  extend FriendlyId
  friendly_id :year, use: :slugged

  ##################
  ## SCOPES
  ##################
  def self.unique
    select('year').distinct.pluck(:year).uniq.sort
  end

  def self.most_recent_year
    unique.last
  end

  def self.sorted_desc
    order('years desc')
  end
end
