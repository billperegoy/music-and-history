class CreateComposerAliases < ActiveRecord::Migration
  def change
    create_table :composer_aliases do |t|
      t.string :name
      t.integer :composer_id

      t.timestamps null: false
    end
  end
end
