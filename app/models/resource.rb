class Resource < ActiveRecord::Base
  validates :text, presence: true
end
