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

  # @param host_exprs A single string with multiple host expressions separated by commas
  # Splits a comma-delimited string of host exprs.  This is tricky since there may be commas within brackets
  def self.split_host_exprs(host_exprs_str)
    host_exprs = []
    expr = ""
    in_brackets = false
    host_exprs_str.each_char do |c|
      if c == "," && !in_brackets
        host_exprs << expr
        expr = ""
        next
      elsif c == "["
        in_brackets = true
      elsif c == "]"
        in_brackets = false
      end
      expr << c
    end
    host_exprs << expr if expr != ""
    host_exprs
  end

  # Parses JSON from a list of host expressions, as passed to expand_host_expr.  Basically a combination
  # of expand_host_expr, create_urls_from_host_params, and download_and_parse_json_from_urls.
  #
  # @param hosts A list of host expressions, as passed to expand_host_expr
  # @param port The integer port to query
  # @param route The string after / for getting metrics, defaults to "metricz/"
  # @param timeout The timeout in seconds for fetching data
  # @returns A hash { hostname => json_tree }
  def self.parse_json_from(hosts, port, route = "metricz/", timeout = 5)
    expanded_hosts = hosts.map { |expr| MetricsDownloader.expand_host_expr(expr) }.flatten
    urls = MetricsDownloader.create_urls_from_host_params(expanded_hosts, port, route)
    json_trees = MetricsDownloader.download_and_parse_json_from_urls(urls, timeout)
    Hash[expanded_hosts.zip(json_trees)]
  end
end