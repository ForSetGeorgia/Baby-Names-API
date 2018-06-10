class ChangeYearColumnNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :years, :amount_total_change, :amount_overall_change
    rename_column :years, :amount_total_change_percent, :amount_overall_change_percent
  end
end
