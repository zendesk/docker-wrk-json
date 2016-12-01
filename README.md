# Portable benchmarking using wrk and Docker.

This repository contains **Dockerfile** of [Debian](https://www.debian.org/) for [Docker](https://www.docker.com/)'s 
[automated build](https://registry.hub.docker.com/u/czerasz/monit-base/) published to the public 
[Docker Hub Registry](https://registry.hub.docker.com/).

Analysing the `Dockerfile` one can get an overview how to install wrk from source.

This project delivers a [wrk](https://github.com/wg/wrk) environment with the ability to create JSON POST requests to 
allow the Zodiac team a portable way to run `wrk` benchmarks.

Inspired by [this post](http://czerasz.com/2015/07/19/wrk-http-benchmarking-tool-example/) and forked from [here](https://github.com/czerasz/docker-wrk-json).

## Requirements:

- [Docker](http://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

## Usage
Clone this repository change into the directory.

### Container setup

Start all containers:

    ./startdocker.sh
    
### Validate a single request

To run a single request (for debugging etc.):

    curl -X POST "https://c9kgdj9th4.execute-api.us-west-2.amazonaws.com/test" -H "Content-Type: application/json" -d @data/page_view.sample.json -v

Your URL will most likely be different.

Benchmark the application from inside the wrk docker container:

    wrk -t12 -c400 -d60s -s scripts/post-page-view.lua https://c9kgdj9th4.execute-api.us-west-2.amazonaws.com

As soon as you start the benchmark the application container logs should output request details:

    root@wrk:/# wrk -t6 -c200 -d15s -s scripts/post-page-view.lua https://c9kgdj9th4.execute-api.us-west-2.amazonaws.com
    multiplerequests: Found 1 requests
    multiplerequests: Found 1 requests
    multiplerequests: Found 1 requests
    multiplerequests: Found 1 requests
    multiplerequests: Found 1 requests
    multiplerequests: Found 1 requests
    multiplerequests: Found 1 requests
    Running 15s test @ https://c9kgdj9th4.execute-api.us-west-2.amazonaws.com
      6 threads and 200 connections
      Thread Stats   Avg      Stdev     Max   +/- Stdev
        Latency   242.72ms  143.57ms   1.01s    86.92%
        Req/Sec   148.28     48.90   303.00     70.94%
      12711 requests in 15.08s, 5.30MB read
    Requests/sec:    842.92
    Transfer/sec:    359.72KB
    
    
If you need to test a service locally on your host OS, then you can use the `dockerhost` hostname we've injected into the container:

    curl -X POST -H 'Content-Type: application/json' -d @data/page_view.sample.json http://dockerhost:8889/event -v
    
### Tweaking tests

You'll check out the lua code in `scripts/post-page-view.lua` you see it loads in `/data/page_view.requests.json`. The array 
can make more than one request, just add another object if you wish! 

Note that the scripts are copied into the container as the origin implementation using a shared docker-compose volume was not working. 
This means we need to build before we run each time. Hopefully we can fix this in future.  
