#!/usr/bin/env ruby
#
# Check Socket
# ===
#
# Check whether or not we can connect to a port of a certain host
#
# Copyright 2012 Sonian, Inc <chefs@sonian.net>
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/check/cli'
require 'socket'
require 'timeout'

class CheckKafkaSocket < Sensu::Plugin::Check::CLI
  option :host,
    :short => '-H HOSTNAME',
    :long => '--hostname HOSTNAME',
    :description => 'Host to connect to'

  option :port,
    :short => '-p PORT',
    :long => '--port PORT',
    :proc => proc {|a| a.to_i },
    :default => 22

  option :timeout,
    :short => '-t SECS',
    :long => '--timeout SECS',
    :description => 'Connection timeout',
    :proc => proc {|a| a.to_i },
    :default => 30

  def check_socket
    ip_addr = `curl -s http://169.254.169.254/latest/meta-data/local-ipv4`
    config[:host] ||= ip_addr
    begin
      sock = TCPSocket.new(config[:host], config[:port])
    rescue Errno::ECONNREFUSED
      critical "Connection refused by #{config[:host]}:#{config[:port]}"
    rescue Timeout::Error
      critical "Connection or read timed out"
    rescue Errno::EHOSTUNREACH
      critical "Check failed to run: No route to host"
    end
  end

  def run
    result = check_socket
    ok
    #banner =~ /#{config[:pattern]}/ ? ok : warning
  end
end
