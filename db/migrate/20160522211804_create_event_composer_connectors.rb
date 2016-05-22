class CreateEventComposerConnectors < ActiveRecord::Migration
  def change
    create_table :event_composer_connectors do |t|
      t.integer :composer_id
      t.integer :event_id

      t.timestamps null: false
    end
  end
end
