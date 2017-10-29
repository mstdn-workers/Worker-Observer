require 'sinatra'
require 'sinatra/cross_origin'

require 'slim'

configure do
  enable :cross_origin
end

require './database.rb'
# apiのルーティングを追加
require './api.rb'
