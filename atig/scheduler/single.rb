#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-
require 'atig/scheduler/poisson'
module Atig
  module Scheduler
    class Single
      def initialize
        @sum = 0
        @history = []
      end

      def inc(n)
        @sum += n
      end

      def estimate
        Poisson.new(average).calc(0.9)
      end

      def average
        @history.inject(0){|x,y| x + y } / @history.size
      end

      def reset
        @history << @sum
        @sum = 0
      end
    end
  end
end
