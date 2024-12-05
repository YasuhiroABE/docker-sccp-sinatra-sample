class MyApp
  helpers do

    def search_get
      require 'uri'
      require 'httpclient'
      client = HTTPClient.new
      @param_q = params.has_key?(:q) ? params[:q].to_str  : "sccp"
      @param_rows = params.has_key?(:rows) ? params[:rows].to_i : 10
      @param_start = params.has_key?(:start) ? params[:start].to_i : 0
      url = URI::HTTPS.build({:host => "opm00h.u-aizu.ac.jp", :path => '/solr/api/v1/search', :query => "q=#{@param_q}&rows=#{@param_rows}&start=#{@param_start}&wt=json&site="})
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
