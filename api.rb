require 'sinatra'
require 'json'

require './database.rb'

database = NameChangeDetection::Database.instance

get "/api/accounts" do
  accounts = database.accounts(params)

  accounts.to_json
end

get "/api/names" do
  accounts = database.accounts(params)

  id = nil
  id = accounts[0].id if accounts[0] && accounts[1].nil?

  p names = database.names(id)

  names.to_json
end
