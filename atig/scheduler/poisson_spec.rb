#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

require 'atig/scheduler/poisson'

describe Atig::Scheduler::Poisson,"when lamdda is 5" do
  before do
    @poisson = Atig::Scheduler::Poisson.new 5
  end

  it "of 0.1 should be 2" do
    @poisson.calc(0.1).should == 2
  end

  it "of 0.1 should be 8" do
    @poisson.calc(0.9).should == 8
  end
end
