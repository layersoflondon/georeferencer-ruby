require 'her'
require 'oj'
require 'require_all'
require "active_support/all"
require 'digest'


module Georeferencer

  API_PATH = 'api/v1'

  class << self
    attr_accessor :configuration
    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
      self.configuration.configure_connection
    end
  end

  class Configuration
    attr_accessor :proxy, :ssl_options, :perform_caching, :cache, :subdomain, :logger, :user_agent
    attr_reader :connection, :user_agent

    def initialize
      @connection ||= Her::API.new
      @ssl_options = {}
      @proxy = nil
      @user_agent = "Georeferencer Ruby Client #{Georeferencer::VERSION} (https://github.com/layersoflondon/georeferencer-ruby)"
      @cache = ActiveSupport::Cache.lookup_store(:memory_store)
      @perform_caching = false
      @logger = Logger.new(STDOUT)
    end
    
    def configure_connection
      raise ArgumentError, "you need to specify a georeferencer subdomain" unless @subdomain.present?
      @connection.setup url: "https://#{@subdomain}.georeferencer.com/#{Georeferencer::API_PATH}", ssl: @ssl_options, proxy: @proxy do |c|

        # Request
        c.use Georeferencer::Headers
        
        c.use Faraday::Request::UrlEncoded

        # Response
        c.use Georeferencer::Parser

        # Adapter
        c.use Faraday::Adapter::NetHttp
      end
    end

  end

  class Error < StandardError

  end
end

require_rel 'georeferencer/mixins'
require_rel 'georeferencer/middleware'
require_rel 'georeferencer/models'
if defined?(Rails)
  require 'georeferencer/engine'
end

Her::Model::Relation.prepend(Georeferencer::CollectionIterator)
Her::Model::Relation.prepend(Georeferencer::CollectionCache)
