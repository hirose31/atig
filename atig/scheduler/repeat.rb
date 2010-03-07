#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

module Atig
  module Scheduler
    class Repeat
      def init(name, delay); end
      def with(name, count); end
      def [](name); 42 end
      def reset(count, hour); end

    end
  end
end
