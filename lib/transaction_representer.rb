require './lib/pagination_representer'

module TransactionRepresenter
  include Roar::Representer::JSON::HAL
  include Roar::Representer::Feature::Hypermedia

  property :desc
  property :date
  property :auth
  property :acc_amount


  link :self do
    "/transactions/#{id}"
  end
end

module TransactionsRepresenter
  include Roar::Representer::JSON::HAL
  include Roar::Representer::Feature::Hypermedia
  include PaginationRepresenter

  collection :items, :extend => TransactionRepresenter

  def page_url(*args)
    '/transactions'
  end
end

module GroupedTransaction
  include Roar::Representer::JSON::HAL

  property :date
  property :sum
end

module GroupedTransactionsRepresenter
  include Roar::Representer::JSON::HAL
  include Roar::Representer::Feature::Hypermedia

  collection :items, :extend => GroupedTransaction

  def items
    self
  end
end
