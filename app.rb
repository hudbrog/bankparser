require './config/environment'
require 'sinatra/base'

class BankRoller < Sinatra::Base
  get '/' do
    erb :index
  end

  get '/transactions' do
    @transactions = Transaction.all
    @transactions.to_json
  end

  get '/transactions/:id' do
    @transaction = Transaction.find(params[:id])
    @transaction.to_json
  end

  post '/transactions/new' do
    @transaction = Transaction.create(params)
  end

end
