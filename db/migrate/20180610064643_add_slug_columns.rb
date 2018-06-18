class AddSlugColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :names, :slug, :string
    add_index  :names, :slug, unique: true
  end
end
