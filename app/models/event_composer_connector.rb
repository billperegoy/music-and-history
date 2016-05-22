class EventComposerConnector < ActiveRecord::Base
  belongs_to :composer
  belongs_to :event
end
