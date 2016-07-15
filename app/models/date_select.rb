class DateSelect 
  include ActiveModel::Model
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :start_month, :start_day, :start_year
  attr_accessor :end_month, :end_day, :end_year

  validates :start_month,
    presence: true

  validates :end_month,
    presence: true

  validates :start_day,
    presence: true

  validates :end_day,
    presence: true

  validates :start_year,
    presence: true

  validates :end_year,
    presence: true
end
