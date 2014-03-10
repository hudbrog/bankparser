require './config/environment'
require 'sinatra/base'


class BankRoller < Sinatra::Base
  configure do
    set :public_folder, File.dirname(__FILE__) + '/app'
  end

  before do
    cache_control :public, :max_age => 0
    content_type 'application/json'
  end

  get '/' do
    send_file(File.dirname(__FILE__) + '/app/index.html', {type: 'text/html'})
  end

  get '/transactions' do
    params[:sort] = '{"date": "asc"}' if params[:sort].nil?
    @transactions = Transaction
      .all
      .order(Hash[JSON.parse(params[:sort]).map {|k,v| [k, v.to_sym]}])
      .paginate(page: params[:page], per_page: params[:per_page])
    @transactions.extend(TransactionsRepresenter)
    @transactions.to_json
  end

  get '/grouped_transactions' do
    @transactions = Transaction
      .select('date, sum(acc_amount) as sum')
      .where("date > '#{Date.parse((Time.now-14.days).to_s)}' and acc_amount < 0 and hidden = false")
      .group('date').to_a
    @transactions.extend(GroupedTransactionsRepresenter).to_json
  end

  get '/transactions/:id' do
    @transaction = Transaction.find(params[:id])
    @transaction.extend(TransactionRepresenter).to_json
  end

  post '/transactions/:id' do
    raw = request.env["rack.input"].read

    @transaction = Transaction.find(params[:id])
    @transaction.extend(TransactionRepresenter)

    # hack, but so far I see no other way
    if @transaction.category.nil? and !JSON.parse(raw)['category'].nil?
      @transaction.category = Category.find(JSON.parse(raw)['category']['id'])
      @transaction.save!
    end

    @transaction.from_json(raw)
    @transaction.save!
    200
  end

  post '/transactions' do
    @transaction = Transaction.create(params)
  end

  get '/categories' do
    params[:sort] = '{"name": "asc"}' if params[:sort].nil?
    @categories = Category
      .all
      .order(Hash[JSON.parse(params[:sort]).map {|k,v| [k, v.to_sym]}])
      .paginate(page: params[:page], per_page: params[:per_page])
    @categories.extend(CategoriesRepresenter)
    @categories.to_json
  end

  post '/categories' do
    @categorie = Category.create(params)
  end

  get '/categories/:id' do
    @category = Category.find(params[:id])
    @category.extend(CategoryRepresenter).to_json
  end

  get '/categories/:id/hints' do
    #@category = Category.find(params[:id])
    @hints = Hint
      .where(category_id: params[:id])
      .paginate(page: params[:page], per_page: params[:per_page])
    @hints.extend(HintsRepresenter)
    @hints.to_json
  end

  get '/categories/:id/hints/:hint_id' do
    @hint = Hint.find(params[:hint_id])
    @hint.extend(HintRepresenter).to_json
  end

  post '/categories/:id/hints/:hint_id' do
    raw = request.env["rack.input"].read

    @hint = Hint.find(params[:hint_id])
    @hint.extend(HintRepresenter)

    @hint.from_json(raw)
    @hint.save!
    200
  end

  post '/categories/:id/hints' do
    raw = request.env["rack.input"].read
    @hint = Hint.create(JSON.parse(raw))
    200
  end
end
