#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

require 'ostruct'

module Atig
  module Scheduler
    class Repeat
      def initialize
        @entries = {}
        @unit    = 1.0
      end

      def init(name, delay)
        @entries[name] = OpenStruct.new({
                                          :ratio => delay,
                                          :count => 0,
                                          :api_count => 0
                                        })
      end

      def with(name, count)
        @entries[name].count += 1
        @entries[name].api_count += count
      end

      def [](name)
        @entries[name].ratio * @unit
      end

      def reset(count, span)
        @unit = @entries.inject(0){|x,y|
          _, entry = y
          estimate = entry.api_count.to_f / entry.count
          x + estimate / entry.ratio
        } * span / count
      end
    end
  end
end
