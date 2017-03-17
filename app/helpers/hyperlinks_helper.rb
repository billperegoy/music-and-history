module HyperlinksHelper
  def sort_by_link_name(links)
   links.sort_by { |item| item.name }
  end
end
