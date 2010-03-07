#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-
require "atig/scheduler/repeat"

describe Atig::Scheduler::Repeat, "when is used by multi repeat handler" do
  HOUR = 60 * 60

  before do
    @repeat = Atig::Scheduler::Repeat.new

    # repeatハンドラの初期情報を登録する
    @repeat.init :a, 30
    @repeat.init :b, 30

    @repeat.with :a, 2
    @repeat.with :b, 1

    @repeat.reset 120, HOUR
  end

  it "should return just delay" do
    (HOUR / @repeat[:a] * 2 + HOUR / @repeat[:b] * 1).should == 120
  end

  it "should return same delay" do
    @repeat[:a].should == @repeat[:b]
  end
end

describe Atig::Scheduler::Repeat, "when is used by multi repeat handler" do
  HOUR = 60 * 60

  before do
    @repeat = Atig::Scheduler::Repeat.new

    # repeatハンドラの初期情報を登録する
    @repeat.init :a, 30
    @repeat.init :b, 120

    @repeat.with :a, 2
    @repeat.with :b, 1

    @repeat.reset 120, HOUR
  end

  it "should return just delay" do
    (HOUR / @repeat[:a] * 2 + HOUR / @repeat[:b] * 1).should == 120
  end

  it "should return same delay" do
    (4 * @repeat[:a]).should == @repeat[:b]
  end
end
