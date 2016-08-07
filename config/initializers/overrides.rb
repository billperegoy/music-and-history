
# Need to override this Field::Text method
# to allow search.
#
require "administrate/field/text"
module Administrate
  module Field
    Text.class_eval do
      def self.searchable?
        true 
      end
    end
  end
end
