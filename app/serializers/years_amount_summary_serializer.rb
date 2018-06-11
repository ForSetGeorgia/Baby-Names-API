class YearsAmountSummarySerializer < ActiveModel::Serializer
  attributes :year, :total_births, :total_unique_names,
    :total_girl_births, :total_girl_names,
    :total_boy_births, :total_boy_names

end
