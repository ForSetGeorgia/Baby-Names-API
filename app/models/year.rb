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

  def self.sorted_year_desc
    order('years.year desc')
  end

  def self.sorted_amount_desc
    order('years.amount desc')
  end

  def self.with_year(year)
    where('years.year = ?', year)
  end

  def self.with_name
    joins(:name)
  end

  def self.select_years_and_names
    select('years.*, names.name_ka, names.name_en, names.gender, names.slug as name_slug')
  end



  def self.name_search(q=nil)
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
    x.select_years_and_names.with_name.with_year(Year.most_recent_year).sorted_amount_desc
  end

  # find the name and get all years
  def self.name_details(name_slug)
    name_id = Name.friendly.find(name_slug).id

    where('years.name_id = ?', name_id).select_years_and_names.with_name.sorted_year_desc
  end



  def self.most_popular_for_year(year, rank_limit=10)
    where(year: year).where('years.overall_rank <= ?', rank_limit)
    .select_years_and_names.with_name
    .order('years.overall_rank asc, names.name_ka asc')
  end

  def self.most_popular_for_year_and_gender(year, gender, rank_limit=10)
    where(year: year).where('years.gender_rank <= ?', rank_limit)
    .select_years_and_names.with_name.where('names.gender = ?', gender)
    .order('years.gender_rank asc, names.name_ka asc')
  end

  def self.least_popular_for_year(year, rank_limit=10)
    # first get year ids and rank
    # then get the number of unique ranks that match rank_limit
    # then get the data
    records = select('years.id, years.overall_rank')
              .where('years.year = ? and years.overall_rank is not null', year)
              .order('years.overall_rank desc')

    ranks = records.map{|x| x.overall_rank}.uniq.take(rank_limit)
    ids = records.select{|x| ranks.include?(x.overall_rank)}

    where(years: {id: ids})
    .select_years_and_names.with_name
    .order('years.overall_rank desc, names.name_ka asc')
  end

  def self.least_popular_for_year_and_gender(year, gender, rank_limit=10)
    # first get year ids and rank
    # then get the number of unique ranks that match rank_limit
    # then get the data
    records = select('years.id, years.gender_rank')
              .where('years.year = ? and years.gender_rank is not null', year)
              .with_name.where('names.gender = ?', gender)
              .order('years.gender_rank desc')

    ranks = records.map{|x| x.gender_rank}.uniq.take(rank_limit)
    ids = records.select{|x| ranks.include?(x.gender_rank)}

    where(years: {id: ids})
    .select_years_and_names.with_name
    .order('years.gender_rank desc, names.name_ka asc')
  end



  def self.largest_amount_increase_for_year(year, limit=10)
    where(year: year).where('amount_year_change > 0')
    .select_years_and_names.with_name
    .order('years.amount_year_change desc, names.name_ka asc')
    .limit(limit)
  end

  def self.largest_amount_increase_for_year_and_gender(year, gender, limit=10)
    where(year: year).where('amount_year_change > 0')
    .select_years_and_names.with_name.where('names.gender = ?', gender)
    .order('years.amount_year_change desc, names.name_ka asc')
    .limit(limit)
  end

  def self.largest_amount_decrease_for_year(year, limit=10)
    where(year: year).where('amount_year_change < 0')
    .select_years_and_names.with_name
    .order('years.amount_year_change asc, names.name_ka asc')
    .limit(limit)
  end

  def self.largest_amount_decrease_for_year_and_gender(year, gender, limit=10)
    where(year: year).where('amount_year_change < 0')
    .select_years_and_names.with_name.where('names.gender = ?', gender)
    .order('years.amount_year_change asc, names.name_ka asc')
    .limit(limit)
  end



  # for each year, count how many babies were born and how many unique names there were
  def self.years_amount_summary
    select(
      'years.year,
      sum(years.amount) as total_births,
      count(years.amount) as total_unique_names,
      sum(case when names.gender = \'g\' then years.amount else 0 end) as total_girl_births,
      sum(case when names.gender = \'b\' then years.amount else 0 end) as total_boy_births,
      sum(case when names.gender = \'g\' then 1 else 0 end) as total_girl_names,
      sum(case when names.gender = \'b\' then 1 else 0 end) as total_boy_names'
    )
    .where('years.amount > 0')
    .with_name
    .group('years.year')
    .sorted_year_desc
  end

  # for each year, create a range of and count how many amounts fall into that range
  def self.years_unique_names_summary
    select(
      'year,
      sum(case when amount between 1 and 5 then 1 else 0 end) as "1-5",
      sum(case when amount between 6 and 10 then 1 else 0 end) as "6-10",
      sum(case when amount between 11 and 50 then 1 else 0 end) as "11-50",
      sum(case when amount between 51 and 100 then 1 else 0 end) as "51-100",
      sum(case when amount between 101 and 500 then 1 else 0 end) as "101-500",
      sum(case when amount between 501 and 1000 then 1 else 0 end) as "501-1000",
      sum(case when amount > 1000 then 1 else 0 end) as ">1000",
      sum(1) as total_unique_names'
    )
    .where('amount > 0')
    .group(:year)
    .sorted_year_desc
  end


  ##################
  ## METHODS
  ##################
  def locale_name
    I18n.locale == :en ? self.name_en : self.name_ka
  end

end
