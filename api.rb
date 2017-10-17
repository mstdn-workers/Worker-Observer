require 'sinatra'
require 'slim'
require './database.rb'

get '/' do
  slim :index
end
