#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-
require 'atig/scheduler/scheduler'
describe Atig::Scheduler::Scheduler do
  before do
    @api = mock('api')
    @api.stub!(:limit).and_return(10)
    @scheduler = Atig::Scheduler::Scheduler.new @api
  end

  it "should have single api call" do
    @api.should_receive(:get).with
    @scheduler.single do|t|
      t.get
    end
  end

  it "should register repeat handler" do
    @api.should_receive(:get).with.at_least(2)
    @scheduler.repeat(0.1) do|t|
      t.get
    end
    sleep 0.5
  end

  it "should work when limit is reset" do
    @scheduler.single do|t|
      @api.stub!(:limit).and_return(20)
    end
  end
end
