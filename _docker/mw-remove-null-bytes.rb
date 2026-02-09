## -*- coding: utf-8 -*-
##https://zenn.dev/yamap_dev/articles/640d91cae4c8dd

class MyApp
  class RemoveNullBytes
    # NOTE: Limit depth level to prevent performance issues
    DEPTH_LIMIT = 3

    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      request.params.each_value do |value|
        remove_null_bytes_recursively(value)
      end
      @app.call(request.env)
    end

    private

    def remove_null_bytes_recursively(value, depth = 0)
      return if depth > DEPTH_LIMIT

      depth += 1
      case value
      when Hash
        value.each_value do |v|
          remove_null_bytes_recursively(v, depth)
        end
      when Array
        value.each do |v|
          remove_null_bytes_recursively(v, depth)
        end
      when String
        value.delete!("\u0000")
      end
    end
  end

  use RemoveNullBytes
end
