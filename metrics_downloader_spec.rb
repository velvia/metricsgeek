require "lib/metrics_downloader"

describe MetricsDownloader, "#split_host_expr" do
  it "should return a single string list if no commas" do
    str = "host1.abc.com"
    MetricsDownloader.split_host_exprs(str).should eq([str])
  end

  it "should return a single string list if commas are in brackets" do
    str = "host[1..3,5,7].abc.com"
    MetricsDownloader.split_host_exprs(str).should eq([str])
  end

  it "should split commas at the right places" do
    expr1 = "host[1..3,5].abc.com"
    expr2 = "host11.abc.com"
    MetricsDownloader.split_host_exprs("#{expr1},#{expr2}").should eq([expr1, expr2])
  end
end