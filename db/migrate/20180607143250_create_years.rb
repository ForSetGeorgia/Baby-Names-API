class CreateYears < ActiveRecord::Migration[5.2]
  def change
    create_table :years do |t|
      t.integer :year
      t.references :name, foreign_key: false
      t.integer :amount
      t.integer :amount_year_change
      t.decimal :amount_year_change_percent
      t.integer :amount_total_change
      t.decimal :amount_total_change_percent
      t.integer :gender_rank
      t.integer :gender_rank_change
      t.integer :overall_rank
      t.integer :overall_rank_change

      t.timestamps
    end

    add_index :years, [:year, :amount]
    add_index :years, [:year, :gender_rank]
    add_index :years, [:year, :overall_rank]
  end
end
