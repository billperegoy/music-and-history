module DateSelectHelper
  def month_options
    ['January', 'February', 'March', 'April', 'May', 'June',
     'July', 'August', 'September', 'October', 'November', 'December']
  end

  def day_options
    (1..31).to_a.map { |d| d.to_s }
  end
end
