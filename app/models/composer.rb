class Composer < ActiveRecord::Base
  has_many :event_composer_connectors
  has_many :events, through: :event_composer_connectors
end
