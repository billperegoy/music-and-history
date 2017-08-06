module HyperlinksHelper
  def sort_by_link_name(links)
   links.sort_by { |item| item.sort_by }
  end
end
