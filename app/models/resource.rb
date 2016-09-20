class Resource < ActiveRecord::Base
  validates :text, presence: true

  def sort_order
    text.downcase.gsub(/<[^>]*>/, '').gsub(/\"/, '')
  end
end
