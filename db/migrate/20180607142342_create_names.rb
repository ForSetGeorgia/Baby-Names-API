class CreateNames < ActiveRecord::Migration[5.2]
  def change
    create_table :names do |t|
      t.string :name_ka
      t.string :name_en
      t.integer :gender

      t.timestamps
    end

    add_index :names, :name_ka
    add_index :names, :name_en
    add_index :names, :gender
  end
end
