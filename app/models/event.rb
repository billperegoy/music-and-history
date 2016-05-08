class Event < ActiveRecord::Base
  def self.by_month(month)
    where('extract(month from date) = ?', month)
  end

  def self.by_day(day)
    where('extract(day from date) = ?', day)
  end
end
