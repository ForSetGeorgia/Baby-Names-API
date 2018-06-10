class Name < ApplicationRecord

  ##################
  ## ASSOCIATIONS
  ##################
  has_many :years, dependent: :destroy

  ##################
  ## VALIDATIONS
  ##################
  validates_presence_of :name_ka, :name_en
  validates_inclusion_of :gender, in: ['m', 'f'], allow_nil: true

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

  def self.search(q=nil)
    x = nil
    if q.nil?
      x = Name.none
    elsif I18n.locale == :ka
      x = where("name_ka LIKE ?", "%#{q}%")
    elsif I18n.locale == :en
      x = where("lower(name_en) LIKE lower(?)", "%#{q}%")
    end

    # add sorting so most popular is first
    x.sort_popular
  end

  # sort the names by how popular they are in the last year
  def self.sort_popular
    with_year(Year.most_recent_year).order('years.amount desc')
  end

  def self.with_year(year)
    joins(:years).where('years.year = ?', year)
  end

  def self.with_years
    joins(:years).order('years.year desc')
  end

  def self.with_most_recent_year
    with_year(Year.most_recent_year)
  end

  ##################
  ## METHODS
  ##################
  def name
    I18n.locale == :en ? self.name_en : self.name_ka
  end
end
