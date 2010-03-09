#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-
require 'atig/util'
require 'atig/scheduler/repeat'
require 'atig/scheduler/single'

module Atig
  module Scheduler
    class Scheduler
      include Util

      def initialize(logger, api)
        @api    = api
        @log    = logger
        @single = Single.new
        @repeat = Repeat.new
        @time   = Time.now
      end

      def single(&f)
        count,res = used(&f)
        @single.inc count
        res
      end

      def repeat(delay,&f)
        t = Thread.new {
          limit, _ = used(&f)
          Thread.stop

          loop {
            safe {
              @repeat.with Thread.current, limit
              sleep @repeat[t]
              limit, _ = used(&f)
            } } }

        @repeat.init t, delay
        log :debug,"repeat handler #{t.object_id} is registered"
        t.run
      end

      private
      def used(&f)
        prev = @api.limit
        res  = f.call @api
        log :debug, "limit becomes #{@api.limit}"
        reset if @api.limit > prev
        [ [ prev - @api.limit, 0 ].max, res ]
      end

      def reset
        @single.reset

        t     = Time.now
        count = @api.limit - @single.estimate
        @repeat.reset count, t - @time

        @time = t
      end
    end
  end
end
