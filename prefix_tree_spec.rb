require 'prefix_tree'

describe PrefixTree do
  let(:tree) { PrefixTree.new }
  describe "#new"
    it "creates root node and store as instance variable" do
      tree.instance_variable_get(:@root).should == Hash.new
    end
  describe "#build" do
    it "creates child node for every input character" do
      tree.build('word')
      tree.instance_variable_get(:@root).keys.should include('w')
      tree.instance_variable_get(:@root)['w'].keys.should include('o')
      tree.instance_variable_get(:@root)['w']['o'].keys.should include('r')
      tree.instance_variable_get(:@root)['w']['o']['r'].keys.should include('d')
    end
    it "sets :end to true for node where word finished" do
      tree.build('word')
      tree.instance_variable_get(:@root)['w'][:end].should_not be_true
      tree.instance_variable_get(:@root)['w']['o']['r']['d'][:end].should be_true
    end
  end
  describe "#find" do
    it "skips original word when looking matches" do
      tree.build('cat')
      tree.find('cat'.split('')).should be_false
    end
    it "returns true if original word can be build with other words from tree" do
      tree.build('cat')
      tree.build('dog')
      tree.find('catdog'.split('')).should be_true
    end
    it "returns false if original word can't be build with other words from tree" do
      tree.build('cat')
      tree.build('dog')
      tree.find('ratdog'.split('')).should be_false
    end
  end
end
describe Task do
  describe "#new" do
    it "builds a prefix tree from the list" do
      tree = double("tree")
      tree.should_receive(:build).with('cat')
      tree.should_receive(:build).with('dog')
      PrefixTree.stub(:new) { tree }      
      Task.new("cat\ndog")
    end
    it "creates a size-sorted array" do
      task = Task.new("cat\nmouse\nhamster")
      task.instance_variable_get(:@sorted_words).should == %w(hamster mouse cat)
    end
    it "reads input from file if stream is not provided" do
      File.should_receive(:read).with('words for problem.txt').and_return("cat\ndog")
      task = Task.new
    end
  end
  describe "#solve" do
    it "returns longest words that can be build from shorter ones in word list" do
       task = Task.new("cat\ncats\ncatsdogcats\ncatxdogcatsrat\ndog\ndogcatsdog\nhippopotamuses\nrat\nratcatdogcat")
       task.solve(2).should == ['ratcatdogcat','catsdogcats']
    end
  end
end