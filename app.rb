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
    @transactions = Transaction.all.order(:date=>:desc).paginate(page: params[:page], per_page: params[:per_page])
    @transactions.extend(TransactionsRepresenter)
    @transactions.to_json
  end

  get '/transactions/:id' do
    @transaction = Transaction.find(params[:id])
    @transaction.extend(TransactionRepresenter).to_json
  end

  post '/transactions/new' do
    @transaction = Transaction.create(params)
  end

end
