require "json"
require "yaml"
require "rest_client"

module MetricsDownloader
  # @returns a list of parsed JSON hashes from each url
  def self.download_and_parse_json_from_urls(urls, timeout = 5)
    threads = urls.map do |url|
      Thread.new do
        Thread.current[:output] = begin
          body = RestClient::Request.execute(:method => :get, :url => url,
                                             :timeout => timeout,
                                             :open_timeout => timeout)
          JSON.parse(body)
        rescue
          # TODO: log the exception?
          STDERR.puts "WARNING: Unable to parse JSON from #{url}"
          {}
        end
      end
    end

    threads.map { |t| t.join; t[:output] }
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

  # @param host_expr A host string with an embedded range [1..18] or individual numbers,
  #                  [1..5,7,9]  =>  1,2,3,4,5,7,9 will be substituted
  # @returns An expanded list of hosts, basically with the range expanded into numbers.
  def self.expand_host_expr(host_expr)
    if host_expr =~ /(\[([0-9.,]+)\])/
      embedded_expr = $1
      numbers = $2.split(",").map { |item| item.include?("..") ? eval(item).to_a : [item.to_i] }.flatten
      numbers.map { |n| host_expr.gsub(embedded_expr, n.to_s) }
    else
      [host_expr]
    end
  end
end