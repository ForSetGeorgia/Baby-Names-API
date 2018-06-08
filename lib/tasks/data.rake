namespace :data do
  desc "Upload the names and count data from CSV into the DB"
  task upload_data: :environment do
    require 'csv'

    start = Time.now
    puts "opening data file"
    data = CSV.open("#{Rails.root}/data/baby_names_2008_2017.csv")

    if data.present?
      # column order:
      # name, gender, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017
      years =* (2008..2017)
      idx_first_year = 2

      # dropping all existing names
      Name.delete_all
      Year.delete_all
      ActiveRecord::Base.connection.execute("TRUNCATE names RESTART IDENTITY CASCADE")

      # for each name:
      # - save ka and en version
      # - for each year, calculate and save numbers
      puts "reading in names"
      Name.transaction do
        data.each_with_index do |row, idx|
          puts "-----------\nname #{idx}; time so far = #{Time.now - start} seconds" if idx%100 == 0
          # skip header row
          if idx > 0
            # create name
            name = Name.create(
              name_ka: row[0].gsub("'", "\""),
              name_en: row[0].gsub("'", "\"").latinize.titlecase,
              gender: row[1].nil? ? nil : row[1].downcase[0]
            )

            # create year
            years.each_with_index do |year, idx_year|
              name_year = name.years.new(year: year)
              name_year.amount = get_value(row[idx_year+1])

              # if this is not the first year, then compute the changes
              if idx_year > 0
                name_year.amount_year_change = name_year.amount - get_value(row[idx_year])
                name_year.amount_total_change = name_year.amount - get_value(row[idx_first_year])

                if get_value(row[idx_year]) > 0
                  name_year.amount_year_change_percent = ((name_year.amount - get_value(row[idx_year])).to_f / get_value(row[idx_year])*100).round(2)
                end
                if get_value(row[idx_first_year]) > 0
                  name_year.amount_total_change_percent = ((name_year.amount - get_value(row[idx_first_year])).to_f / get_value(row[idx_first_year])*100).round(2)
                end
              end
              name_year.save
            end
          end
        end
      end
    end

    puts "Total time #{Time.now - start} seconds"
  end

end

##########################
## helper method for the task above
def get_value(item)
  item.nil? || item.length == 0 ? 0 : item.to_i
end