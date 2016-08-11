class Event < ActiveRecord::Base
  include PgSearch

  validates :description, presence: true
  validates :date, presence: true

  belongs_to :category
  has_many :event_composer_connectors
  has_many :composers, through: :event_composer_connectors
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "none"
  do_not_validate_attachment_file_type :image

  def self.by_month(month)
    where('extract(month from date) = ?', month)
  end

  def self.by_day(day)
    where('extract(day from date) = ?', day)
  end

  scope :date_range, lambda {|start_date, end_date| where("date >= ? AND date <= ?", start_date, end_date )}

  pg_search_scope :search_description, :against => [:description]
end
