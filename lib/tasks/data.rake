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
      ActiveRecord::Base.connection.execute("TRUNCATE names CASCADE")

      # for each name:
      # - save ka, en and gender
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

  desc "Create the overall ranks for all names for each year"
  task generate_overall_ranks: :environment do

    start = Time.now
    years =* (2008..2017)

    Year.transaction do
      years.each do |year|
        current_amount = 0
        rank = 0
        num_records_same_amount = 1
        puts "------------------------\n#{year}, total time so far: #{Time.now-start} seconds"

        Year.where(:year => year).order("amount desc").each_with_index do |record, index|
          puts "-index = #{index}, amount = #{record.amount}, total time so far: #{Time.now-start} seconds" if index%500 == 0
          # only create rank if there is an amount > 0
          if !record.amount.nil? && record.amount > 0
            if record.amount == current_amount
              # found name with same amount
              num_records_same_amount += 1 # increase the num of records with this count
            else
              # found new amount
              current_amount = record.amount # save the new amount value
              rank = rank + num_records_same_amount # increase the rank value
              num_records_same_amount = 1 # reset counter
            end
            # save the rank value
            record.overall_rank = rank
            record.save
          end
        end
      end

      puts "\n TOTAL TIME FOR OVERALL RANK FOR ALL YEARS: #{Time.now - start} seconds"

      # now we can create the rank change value
      # - for each name, compute rank change for each year
      puts "now creating rank change"
      Name.all.each_with_index do |name, index|
        puts "-index = #{index}, total time so far: #{Time.now-start} seconds" if index%500 == 0

        years = name.years.order('year desc')
        years.each_with_index do |year, index|
          # do not need to create change
          # - if this is the first year of 2008
          # - if this year has no rank
          # - if last year has no rank
          if year.year > 2008 && !year.overall_rank.nil? && year.overall_rank > 0 &&
              !years[index+1].overall_rank.nil? && years[index+1].overall_rank > 0
            # need to multiple by -1 to properly show the rank went up or down
            year.overall_rank_change = -1 * (year.overall_rank - years[index+1].overall_rank)
            year.save
          end
        end
      end

    end


    puts "\n TOTAL TIME FOR OVERALL RANK AND RANK CHANGE FOR ALL YEARS: #{Time.now - start} seconds"
  end

  desc "Create the overall ranks for all names for each year and gender"
  task generate_gender_ranks: :environment do

    start = Time.now
    years =* (2008..2017)
    genders = ['m', 'f']

    Year.transaction do
      years.each do |year|
        genders.each do |gender|
          puts "------------------------\n#{year} - #{gender}, total time so far: #{Time.now-start} seconds"

          current_amount = 0
          rank = 0
          num_records_same_amount = 1

          Year.where(:year => year).includes(:name).where(names: {gender: gender}).order("years.amount desc").each_with_index do |record, index|
            puts "-index = #{index}, amount = #{record.amount}, total time so far: #{Time.now-start} seconds" if index%500 == 0
            # only create rank if there is an amount > 0
            if !record.amount.nil? && record.amount > 0
              if record.amount == current_amount
                # found name with same amount
                num_records_same_amount += 1 # increase the num of records with this count
              else
                # found new amount
                current_amount = record.amount # save the new amount value
                rank = rank + num_records_same_amount # increase the rank value
                num_records_same_amount = 1 # reset counter
              end
              # save the rank value
              record.gender_rank = rank
              record.save
            end
          end
        end
      end

      puts "\n TOTAL TIME FOR GENDER RANK FOR ALL YEARS: #{Time.now - start} seconds"

      # now we can create the rank change value
      # - for each name, compute rank change for each year
      puts "now creating rank change"
      Name.all.each_with_index do |name, index|
        puts "-index = #{index}, total time so far: #{Time.now-start} seconds" if index%500 == 0

        years = name.years.order('year desc')
        years.each_with_index do |year, index|
          # do not need to create change
          # - if this is the first year of 2008
          # - if this year has no rank
          # - if last year has no rank
          if year.year > 2008 && !year.gender_rank.nil? && year.gender_rank > 0 &&
              !years[index+1].gender_rank.nil? && years[index+1].gender_rank > 0
            # need to multiple by -1 to properly show the rank went up or down
            year.gender_rank_change = -1 * (year.gender_rank - years[index+1].gender_rank)
            year.save
          end
        end
      end

    end


    puts "\n TOTAL TIME FOR OVERALL RANK AND RANK CHANGE FOR ALL YEARS: #{Time.now - start} seconds"
  end

end

##########################
## helper method for the task above
def get_value(item)
  item.nil? || item.length == 0 ? 0 : item.to_i
end