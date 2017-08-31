# coding: utf-8

require 'rubygems'
require 'bundler/setup'

require 'mastodon'
require 'readline'

require "oauth2"
require 'json'

module Register
  APP_NAME = "Name Change Detecter"
  DEFAULT_CONFIG = {
    "host" => "mstdn-workers.com",
    "scopes" => "read write",
  }
  TOKEN_FILE_NAME = '.access_token'
  DEFAULT_CONFIG_FILE_NAME = 'config.json'

  def init_app
    base_url = 'https://' + config["host"]
    Mastodon::REST::Client.new(base_url: base_url,
                               bearer_token: access_token)
  end

  def config
    if File.exist? DEFAULT_CONFIG_FILE_NAME
      JSON.parse(File.read(DEFAULT_CONFIG_FILE_NAME))
    else
      save_config(DEFAULT_CONFIG)
      DEFAULT_CONFIG
    end
  end

  def save_config(config)
    File.write(DEFAULT_CONFIG_FILE_NAME, JSON.dump(config))
  end
end

include Register
p init_app
