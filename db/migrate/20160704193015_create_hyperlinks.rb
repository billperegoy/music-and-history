class CreateHyperlinks < ActiveRecord::Migration
  def change
    create_table :hyperlinks do |t|
      t.string :name
      t.string :url
      t.integer :link_category_id

      t.timestamps null: false
    end
  end
end
