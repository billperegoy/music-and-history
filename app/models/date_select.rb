class DateSelect 
  include ActiveModel::Model
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :date_range
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
    presence: true, if: "date_range?"

  validates :end_year, 
    presence: true, if: "date_range?"

  def date_range?
    date_range == "1"
  end
end
