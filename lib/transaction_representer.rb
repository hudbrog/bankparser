module TransactionRepresenter
  include Roar::Representer::JSON::HAL
  include Roar::Representer::Feature::Hypermedia

  property :desc
  property :date
  property :auth
  property :acc_amount


  link :self do
    "http://songs/"
  end
end

module TransactionsRepresenter
  include Roar::Representer::JSON::HAL
  include Roar::Representer::Feature::Hypermedia
  include PaginationRepresenter

  collection :items, :extend => TransactionRepresenter

  def page_url(*args)
    'http://blah'
  end
end