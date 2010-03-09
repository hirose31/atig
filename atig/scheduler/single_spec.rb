#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

require 'atig/scheduler/single'

describe Atig::Scheduler::Single do
  before do
    @single = Atig::Scheduler::Single.new
    @single.inc 3
    @single.inc 3
    @single.reset
  end

  it "should accmulate api count" do
    @single.average.should == 6
  end

  it "should have history" do
    @single.inc 2
    @single.reset

    @single.average.should == 4
  end

  it "should return estimate value" do
    @single.estimate.should >= 6
  end
end
