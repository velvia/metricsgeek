require "json"
require "yaml"
require "rest_client"

module MetricsDownloader
  # @returns a list of parsed JSON hashes from each url
  def self.download_and_parse_json_from_urls(urls)
    # TODO: use futures for faster metrics consumption
    urls.map do |url|
      begin
        JSON.parse(RestClient.get url)
      rescue
        # TODO: log the exception?
        STDERR.puts "WARNING: Unable to parse JSON from #{url}"
        {}
      end
    end
  end

  # @param host_list A list of host strings, without the port, optionally with http:// prefix
  # @route the string after the / for getting metrics, defaults to "metricz/"
  # @returns a list of URLs from which to retrieve data
  def self.create_urls_from_host_params(host_list, port, route = "metricz/")
    host_list.map do |host|
      host = host[7..-1] if host.start_with?("http:")
      "http://#{host}:#{port}/#{route}"
    end
  end
end