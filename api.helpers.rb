class MyApp
  helpers do

    def search_get
      require 'uri'
      require 'httpclient'
      client = HTTPClient.new
      @param_q = params.has_key?(:q) ? params[:q].to_str  : ""
      @param_rows = params.has_key?(:rows) ? params[:rows].to_i : 10
      @param_start = params.has_key?(:start) ? params[:start].to_i : 0
      url = nil
      if ENV.fetch("MYSOLR_USE_TLS", "true").downcase == "true"
        url = URI::HTTPS.build({
          :host => ENV.fetch("MYSOLR_HOST", "opm00h.u-aizu.ac.jp"),
          :port => ENV.fetch("MYSOLR_PORT", "443"),
          :path => ENV.fetch("MYSOLR_PATH", '/solr/api/v1/search'),
          :query => ENV.fetch("MYSOLR_QUERY", "q=#{@param_q}&rows=#{@param_rows}&start=#{@param_start}&wt=json")
        })
      else
        url = URI::HTTP.build({
          :host => ENV.fetch("MYSOLR_HOST", "localhost"),
          :port => ENV.fetch("MYSOLR_PORT", "8983"),
          :path => ENV.fetch("MYSOLR_PATH", '/solr/testcore/query'),
          :query => ENV.fetch("MYSOLR_QUERY", "q=content:*#{@param_q}*&rows=#{@param_rows}&start=#{@param_start}&wt=json&hl=on&hl.fl=content&usePhraseHighLighter=true")
        })
      end
      p url
      ret = client.get(url)
      @result = JSON.parse(ret.body)
      output = erb :header
      output += erb :main
      output += erb :footer
    end

    def spec_get
      File.read("openapi.yaml")
    end

  end
end
