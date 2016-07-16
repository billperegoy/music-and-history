class CreatePagePhoros < ActiveRecord::Migration
  def change
    create_table :page_phoros do |t|
      t.string :image
      t.string :caption
      t.integer :page_id

      t.timestamps null: false
    end
  end
end
