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

  def self.most_popular_for_year(year, rank_limit=20)
    where(year: year).where('years.overall_rank <= ?', rank_limit)
    .with_name
    .order('years.overall_rank asc, names.name_ka asc')
  end

  def self.most_popular_for_year_and_gender(year, gender, rank_limit=20)
    where(year: year).where('years.gender_rank <= ?', rank_limit)
    .with_name.where('names.gender = ?', gender)
    .order('years.gender_rank asc, names.name_ka asc')
  end

  def self.least_popular_for_year(year, rank_limit=20)
    # first get year ids and rank
    # then get the number of unique ranks that match rank_limit
    # then get the data
    records = select('years.id, years.overall_rank')
              .where('years.year = ? and years.overall_rank is not null', year)
              .order('years.overall_rank desc')

    ranks = records.map{|x| x.overall_rank}.uniq.take(rank_limit)
    ids = records.select{|x| ranks.include?(x.overall_rank)}

    where(years: {id: ids})
    .with_name
    .order('years.overall_rank desc, names.name_ka asc')
  end

  def self.least_popular_for_year_and_gender(year, gender, rank_limit=20)
    # first get year ids and rank
    # then get the number of unique ranks that match rank_limit
    # then get the data
    records = select('years.id, years.gender_rank')
              .where('years.year = ? and years.gender_rank is not null', year)
              .joins(:name).where('names.gender = ?', gender)
              .order('years.gender_rank desc')

    ranks = records.map{|x| x.gender_rank}.uniq.take(rank_limit)
    ids = records.select{|x| ranks.include?(x.gender_rank)}

    where(years: {id: ids})
    .with_name
    .order('years.gender_rank desc, names.name_ka asc')
  end

  def self.with_name
    select('years.*, names.name_ka, names.name_en, names.gender, names.slug as name_slug').joins(:name)
  end

  ##################
  ## METHODS
  ##################
  def locale_name
    I18n.locale == :en ? self.name_en : self.name_ka
  end

end
