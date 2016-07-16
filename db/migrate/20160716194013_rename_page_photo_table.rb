class RenamePagePhotoTable < ActiveRecord::Migration
  def change
    rename_table :page_phoros, :page_photos
  end
end
