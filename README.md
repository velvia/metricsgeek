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
To get a list of metrics keys from your servers:

    metricsgeek --list_keys --from "server[1..8].abc.com"

To get two metrics, one a pattern, from your servers:

    metricsgeek --select jvm.uptime,com.abc.*.latency.mean --from "server[1..8].abc.com"

Host selection
==============
You can select multiple hosts to query in two ways.

First, individual hosts can be passed, comma separated, to the --from option.

Second, you can pass in a range of numbers within brackets, and this is automatically expanded to separate
hosts.  For example,

    --from server[1..3,5,8..11].dc

expands to

    --from server1.dc,server2.dc,server3.dc,server5.dc,server8.dc,server9.dc,server10.dc,server11.dc

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