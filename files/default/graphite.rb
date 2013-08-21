#!/usr/bin/env ruby

require 'rubygems'
require 'sensu-handler'
require 'simple-graphite'

class GraphiteHandler < Sensu::Handler
  def filter
  end

  def handle
    g = Graphite.new
    g.host = 'localhost'
    g.port = 2003
    g.push_to_graphite do |graphite|
      graphite.puts @event['check']['output']
    end
  end
end

