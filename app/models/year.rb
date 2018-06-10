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
    order('years.year desc')
  end

  def self.sorted_amount_desc
    order('years.amount desc')
  end

  def self.with_name
    select('years.*, names.name_ka, names.name_en, names.gender, names.slug as name_slug').joins(:name)
  end

  def self.with_year(year)
    where('years.year = ?', year)
  end

  def self.search_name(q=nil)
    x = if q.nil?
      Year.none
    elsif I18n.locale == :ka
      where("names.name_ka LIKE ?", "%#{q}%")
    elsif I18n.locale == :en
      where("lower(names.name_en) LIKE lower(?)", "%#{q}%")
    end

    # add name connection
    # limit to most recent year
    # sort by amount desc
    x.with_name.with_year(Year.most_recent_year).sorted_amount_desc
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

  ##################
  ## METHODS
  ##################
  def locale_name
    I18n.locale == :en ? self.name_en : self.name_ka
  end

end
