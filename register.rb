# coding: utf-8

require 'rubygems'
require 'bundler/setup'

require 'mastodon'
require 'readline'

require 'json'

module Register
  attr_reader :config

  APP_NAME = "Name Change Detecter"
  DEFAULT_CONFIG = {
    "host" => "mstdn-workers.com",
    "scopes" => "read write",
  }
  TOKEN_FILE_NAME = '.access_token'
  DEFAULT_CONFIG_FILE_NAME = 'config.json'

  def init_app
    base_url = 'https://' + @config["host"]
    Mastodon::REST::Client.new(base_url: base_url,
                               bearer_token: access_token)
  end
end
