class Hyperlink < ActiveRecord::Base
  validates :name, presence: true
  validates :url, presence: true

  belongs_to :link_category
end
