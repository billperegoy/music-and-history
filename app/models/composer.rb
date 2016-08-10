class Composer < ActiveRecord::Base
  has_many :event_composer_connectors
  has_many :events, through: :event_composer_connectors
  has_many :composer_aliases

  def first_letter_of_last_name
    last_name[0,1]
  end
end
