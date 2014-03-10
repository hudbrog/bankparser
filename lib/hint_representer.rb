require './lib/pagination_representer'
require './lib/category_representer'

module HintRepresenter
  include Roar::Representer::JSON::HAL
  include Roar::Representer::Feature::Hypermedia

  property :id
  property :regex
  property :category_id

  link :self do
    "/categories/#{category_id}/hints/#{id}"
  end
end

module HintsRepresenter
  include Roar::Representer::JSON::HAL
  include Roar::Representer::Feature::Hypermedia
  include PaginationRepresenter

  collection :items, :extend => HintRepresenter

  def page_url(*args)
    '/hints'
  end
end

