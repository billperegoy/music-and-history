require "administrate/base_dashboard"

class LinkCategoryDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    hyperlinks: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    description: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :description,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :name,
    :description,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :description,
  ].freeze

  # Overwrite this method to customize how link categories are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(link_category)
  #   "LinkCategory ##{link_category.id}"
  # end
  def display_resource(link_category)
    "#{link_category.name}"
  end
end
