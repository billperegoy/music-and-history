class AddCaptiontoEvent < ActiveRecord::Migration
  def change
    add_column :events, :caption, :string
  end
end
