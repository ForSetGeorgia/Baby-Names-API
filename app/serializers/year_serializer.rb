class YearSerializer < ActiveModel::Serializer
  attributes :id, :year, :amount,
    :amount_year_change, :amount_year_change_percent,
    :amount_total_change, :amount_total_change_percent,
    :gender_rank, :gender_rank_change,
    :overall_rank, :overall_rank_change

  def id
    "#{object.slug}"
  end

  belongs_to :name
end
