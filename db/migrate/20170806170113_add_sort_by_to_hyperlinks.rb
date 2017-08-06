class AddSortByToHyperlinks < ActiveRecord::Migration
  def change
    add_column :hyperlinks, :sort_by, :string
    Hyperlink.all.each do |link|
      link.update_attributes(:sort_by => link.name)
    end
  end
end
