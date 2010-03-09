#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-
require 'atig/exception_util'
require 'atig/scheduler/repeat'
require 'atig/scheduler/single'

module Atig
  module Scheduler
    class Scheduler
      include ExceptionUtil

      def initialize(api)
        @api    = api
        @single = Single.new
        @repeat = Repeat.new
        @time   = Time.now
      end

      def single(&f)
        @single.inc used(&f)
      end

      def repeat(delay,&f)
        t = Thread.new {
          Thread.stop
          loop {
            safe {
              @repeat.with Thread.current, used(&f)
              sleep @repeat[t]

            } } }

        @repeat.init t, delay
        t.run
      end

      private
      def used(&f)
        prev = @api.limit
        f.call @api
        reset if @api.limit > prev
        [ prev - @api.limit, 0 ].max
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
