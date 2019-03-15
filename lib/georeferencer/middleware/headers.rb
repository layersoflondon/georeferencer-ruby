module Georeferencer
  class Headers < Faraday::Middleware
    def call(env)
      # Add custom UA String
      env[:request_headers]["User-Agent"] = Georeferencer.configuration.user_agent


      # Fix url-encoded percent signs
      env.url.query = env.url.query.gsub(/%25/,'%')

      @app.call(env)
    end
  end
end