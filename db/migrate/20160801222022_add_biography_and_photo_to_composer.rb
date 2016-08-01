class AddBiographyAndPhotoToComposer < ActiveRecord::Migration
  def change
    add_column :composers, :biography, :text
    add_column :composers, :photo, :string
  end
end
