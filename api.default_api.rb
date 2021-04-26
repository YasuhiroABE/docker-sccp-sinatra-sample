require 'json'


MyApp.add_route('GET', '/search', {
  "resourcePath" => "/Default",
  "summary" => "",
  "nickname" => "search_get", 
  "responseClass" => "void",
  "endpoint" => "/search", 
  "notes" => "e.g. /search?q=query-words",
  "parameters" => [
    {
      "name" => "q",
      "description" => "",
      "dataType" => "String",
      "allowableValues" => "",
      "paramType" => "query",
    },
    {
      "name" => "start",
      "description" => "",
      "dataType" => "Integer",
      "allowableValues" => "",
      "defaultValue" => "0",
      "paramType" => "query",
    },
    {
      "name" => "rows",
      "description" => "",
      "dataType" => "Integer",
      "allowableValues" => "",
      "defaultValue" => "10",
      "paramType" => "query",
    },
    ]}) do
  cross_origin
  # the guts live here
  
  require 'uri'
  require 'httpclient'
  client = HTTPClient.new
  @param_q = params.has_key?(:q) ? params[:q].to_str  : "sccp"
  url = URI::HTTPS.build({:host => "opm00h.u-aizu.ac.jp", :path => '/solr/api/v1/search', :query => "q=#{@param_q}&wt=json"})
  ret = client.get(url)
  @result = JSON.parse(ret.body)
  output = erb :header
  output += erb :main
  output += erb :footer
end


MyApp.add_route('GET', '/.spec', {
  "resourcePath" => "/Default",
  "summary" => "",
  "nickname" => "spec_get", 
  "responseClass" => "void",
  "endpoint" => "/.spec", 
  "notes" => "providing the openapi schema YAML file.",
  "parameters" => [
    ]}) do
  cross_origin
  # the guts live here
  File.read("openapi.yaml")
end

