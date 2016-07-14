class Event < ActiveRecord::Base
  include PgSearch

  belongs_to :category
  has_many :event_composer_connectors
  has_many :composers, through: :event_composer_connectors

  def self.by_month(month)
    where('extract(month from date) = ?', month)
  end

  def self.by_day(day)
    where('extract(day from date) = ?', day)
  end

  scope :date_range, lambda {|start_date, end_date| where("date >= ? AND date <= ?", start_date, end_date )}

  pg_search_scope :search_description, :against => [:description]
end
