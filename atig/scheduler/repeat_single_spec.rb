#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-
require "atig/scheduler/repeat"

describe Atig::Scheduler::Repeat, "when is used by single repeat handler" do
  HOUR = 60 * 60

  before do
    @repeat = Atig::Scheduler::Repeat.new

    # repeatハンドラの初期情報を登録する
    @repeat.init :a, 30
  end

  it "should return initial delay" do
    @repeat[:a].should == 30
  end

  it "should return delay" do
    # 呼び出しのたびに、使用回数を登録する
    @repeat.with :a, 2

    # 残りリセット
    @repeat.reset 120, HOUR

    # repeatハンドラのdelayを得られる
    (HOUR / @repeat[:a] * 2).should == 120
  end

  it "should use average of call" do
    @repeat.with :a, 4
    @repeat.with :a, 2
    @repeat.with :a, 3

    @repeat.reset 120, HOUR
    (HOUR / @repeat[:a] * 3).should == 120
  end
end
