require 'sinatra'
require 'json'

require './database.rb'

database = NameChangeDetection::Database.instance

get "/api/accounts" do
  accounts = database.accounts(params)

  accounts.to_json
end

get "/api/names" do
  names = database.names(params)

  names.to_json
end
