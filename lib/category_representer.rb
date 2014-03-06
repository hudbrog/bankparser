require './lib/pagination_representer'

module CategoryRepresenter
  include Roar::Representer::JSON::HAL
  include Roar::Representer::Feature::Hypermedia

  property :id
  property :name

  link :self do
    "/categories/#{id}"
  end
end

module CategoriesRepresenter
  include Roar::Representer::JSON::HAL
  include Roar::Representer::Feature::Hypermedia
  include PaginationRepresenter

  collection :items, :extend => CategoryRepresenter

  def page_url(*args)
    '/categories'
  end
end

