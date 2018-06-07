namespace :data do
  desc "Upload the name data from CSV into the DB"
  task upload_names: :environment do
    require 'csv'
    connection = ActiveRecord::Base.connection()
    time = Time.now.strftime('%Y-%m-%d %H:%M')

    puts "opening data file"
    data = CSV.open("#{Rails.root}/data/baby_names_2008_2017.csv")

    if data.present?
      names = []

      # dropping all existing names
      ActiveRecord::Base.connection.execute("TRUNCATE names RESTART IDENTITY")

      # read in the names
      puts "reading in names"
      data.each_with_index do |row, i|
        # skip header row
        if i > 0
          names << "('#{row[0].gsub("'", "\"")}', '#{row[0].gsub("'", "\"").latinize.titlecase}', '#{time}', '#{time}') "
        end
      end

      # load the names to the db
      puts "loading to db"
      sql = "insert into names(name_ka, name_en, created_at, updated_at) values "
      sql << names.join(', ')
      connection.execute(sql)


    end

  end

end
