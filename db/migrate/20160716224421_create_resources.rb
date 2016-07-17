class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :text

      t.timestamps null: false
    end
  end
end
