class YearsUniqueNamesSummarySerializer < ActiveModel::Serializer
  attributes :year, :total_unique_names, :data

  def data
    {
      '1-5': object['1-5'],
      '6-10': object['6-10'],
      '11-50': object['11-50'],
      '51-100': object['51-100'],
      '101-500': object['101-500'],
      '501-1000': object['501-1000'],
      '>1000': object['>1000'],
    }
  end
end
