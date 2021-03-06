require 'spec_helper'
require 'prj/filter'

describe "Prj::Filter" do
  def filter(letters)
    Prj::Filter.new(letters)
  end

  describe "#dispersion" do
    it "should calculate dispersion as difference between character positions except first character position" do
      filter(%w(f o)).dispersion("foo bar").should == 0
      filter(%w(f b)).dispersion("foo bar").should == 3
    end
  end

  describe "#filter" do
    it "filters based on ordered occurrences" do
      dirs = ["foos", "bars", "quxs"]
      filter(%w(f o)).filter(dirs).should == ["foos"]
    end

    it "counts same chars correctly" do
      dirs = ["solar studio", "mars maraphone", "way too complex", "totla madness"]
      filter(%w(s s)).filter(dirs).should =~ ["solar studio", "totla madness"]
      filter(%w(o o)).filter(dirs).should =~ ["solar studio", "way too complex"]
      filter(%w(a a)).filter(dirs).should =~ ["mars maraphone", "totla madness"]
      filter(%w(r o)).filter(dirs).should =~ ["solar studio", "mars maraphone"]
      filter(%w(x x)).filter(dirs).should == []
      filter(%w(m a d n e)).filter(dirs).should =~ ["totla madness"]
    end

    it "sorts by dispersion" do
      dirs = ["/koans/", "/omniauth/", "/ruby-download/"]
      filter(%w(o a)).filter(dirs).should == ["/koans/", "/omniauth/", "/ruby-download/"]
    end

    it "sorts by length for lines when dispersion is same" do
      dirs = ["/franchise/", "/granny/"]
      filter(%w(a n)).filter(dirs).should == ["/granny/", "/franchise/"]

      dirs = ["/granny/", "/franchise/"]
      filter(%w(a n)).filter(dirs).should == ["/granny/", "/franchise/"]
    end
  end

end

