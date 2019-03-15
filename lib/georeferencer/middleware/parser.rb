module Georeferencer
  class Parser < Faraday::Response::Middleware
    def on_complete(env)
      json = Oj.load(env[:body], symbolize_keys: true)
      if json.has_key?("@list")
        start = nil

        if json["next"].present?
          query = URI.parse(json["next"]).query
          start = query.scan(/start=([^$]+)/).flatten.first
        end

        body = {
          data: json["@list"]
        }

        body.merge!({metadata: {start: start}})
        env[:body] = body
      else
        env[:body] = {
          data: json.with_indifferent_access
        }
      end
    end
  end

end
