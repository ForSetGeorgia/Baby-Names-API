class Name < ApplicationRecord

  ##################
  ## ASSOCIATIONS
  ##################
  has_many :years, dependent: :destroy

  ##################
  ## VALIDATIONS
  ##################
  validates_presence_of :name_ka, :name_en
  validates_inclusion_of :gender, in: ['b', 'g'], allow_nil: true

  ##################
  ## URL SLUGS
  ##################
  extend FriendlyId
  friendly_id :name_ka, use: :slugged

  # for genereate friendly_id
  def should_generate_new_friendly_id?
  #    name_changed? || super
    super
  end

  # for locale sensitive transliteration with friendly_id
  def normalize_friendly_id(input)
    input.to_s.to_url
  end

  ##################
  ## SCOPES
  ##################
  def self.with_gender(gender)
    where(gender: gender)
  end

  def self.with_years
    joins(:years).order('years.year desc')
  end

  ##################
  ## METHODS
  ##################
  def name
    I18n.locale == :en ? self.name_en : self.name_ka
  end
end
