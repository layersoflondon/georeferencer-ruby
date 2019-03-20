module Georeferencer
  class Headers < Faraday::Middleware
    def call(env)
      # Add custom UA String
      env[:request_headers]["User-Agent"] = Georeferencer.configuration.user_agent

      query = Faraday::Utils.parse_query(env.url.query) || {}
      query["format"] = 'json'

      # Fix url-encoded percent signs
      env.url.query = Faraday::Utils.build_query(query).gsub(/%25/,'%')

      @app.call(env)
    end
  end
end