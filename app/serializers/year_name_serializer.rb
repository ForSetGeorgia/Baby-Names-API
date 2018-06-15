class YearNameSerializer < ActiveModel::Serializer
  attributes :id, :name, :gender,
    :year, :amount,
    :amount_year_change, :amount_year_change_percent,
    :amount_overall_change, :amount_overall_change_percent,
    :gender_rank, :gender_rank_change,
    :overall_rank, :overall_rank_change

  def id
    "#{object.name_slug}"
  end

  def name
    "#{object.locale_name}"
  end

  def gender
    "#{object.gender == 'g' ? 'Girl' : object.gender == 'b' ? 'Boy' : '' }"
  end

end
