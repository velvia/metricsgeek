Easily grok and analyze your application metrics from a cluster, in real time, with this command line tool /
gem. Compatible with HTTP JSON metrics routes as exposed by Coda Hale's metrics package, Jolokia, ruby-
metrics, or any metrics package that exposes metrics via an HTTP route as JSON.

The only assumption is that the JSON consists of deeper and deeper levels of hashes.

* Get metrics in real time, no need to wait minutes for a central service to index your logs
* Easily see load and traffic imbalances across a cluster
* Select and filter metrics easily using wildcards
* Group and summarize metrics

Quick start
===========
Install this gem:

    gem install metricsgeek

To get a list of metrics keys from your servers:

    metricsgeek --list-keys --from "server[1..8].abc.com"

To get two metrics, one a pattern, from your servers:

    metricsgeek --select jvm.uptime,com.abc.*.latency.mean --from "server[1..8].abc.com"

Port and Route
==============
The port defaults to 7000 and the route defaults to /metricz.  Both of these can be set via the --port and
--route options.

Host selection
==============
You can select multiple hosts to query in two ways.

First, individual hosts can be passed, comma separated, to the --from option.

Second, you can pass in a range of numbers within brackets, and this is automatically expanded to separate
hosts.  For example,

    --from server[1..3,5,8..11].dc

expands to

    --from server1.dc,server2.dc,server3.dc,server5.dc,server8.dc,server9.dc,server10.dc,server11.dc

The above two features can be combined:

    --from server[1..3,5,8].dc,server-prod-us-east[11..13].aws.com

Metrics selection
=================
You can use the --list_keys option together with --from to list all the metrics keys available for querying.
This is done by flattening the JSON output from all the routes, with successive levels of JSON separated by
dots in the flat metric key.

The --select option takes one or more metric keys separated by commas.  So,

    --select jvm.uptime,my.app.*.latency

Note that you can use the * wildcard character to select multiple metrics keys, as well as [12] style
character selection.

Grouping metrics
================
Intead of displaying metrics from every host on a separate line, you can group the metrics together from all hosts using one of four functions: sum, min, max, avg.  For example, to compute the average uptime of all hosts:

    metricsgeek --select jvm.uptime --from "server[1..8].dc" --group avg

Or, to sum up the POST rate from metric com.abc.webservice.posts.m1 across the cluster:

    metricsgeek --select com.abc.webservice.posts.m1 --from "server[1..8].dc" --group sum

How to contribute
=================
You can run the test like this:

    rspec metrics_downloader_spec.rb

Pull requests are welcome!