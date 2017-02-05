class Composer < ActiveRecord::Base
  has_many :event_composer_connectors
  has_many :events, through: :event_composer_connectors
  has_many :composer_aliases


  validates :last_name, presence: true

  default_scope { order(last_name: :asc, first_name: :asc) }

  def first_letter_of_last_name
    last_name[0,1]
  end
end
