class AddDescriptionToLinkCategory < ActiveRecord::Migration
  def change
    add_column :link_categories, :description, :string

  end
end
