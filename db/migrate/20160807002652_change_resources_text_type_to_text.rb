class ChangeResourcesTextTypeToText < ActiveRecord::Migration
  def change
    change_column :resources, :text, :text
  end
end
