class PrefixTree
  ##
  # Creates a prefix tree based on input and
  # allows to search for words efficiently, responding
  # if current word can be built using shorter words
  # from the tree

  def initialize
    @root = Hash.new
  end
 
  def build(str)
    # Expects one word at a time as String object
    # and adds it to the tree

    node = @root    
    str.each_char do |ch|
      node[ch] ||= Hash.new
      node = node[ch]
    end
    node[:end] = true
  end
 
  def find(array, original = true)
    # Expects search word as array of characters
    # Returns boolean if word can be built using
    # shorter words from the word list

    node = @root
    array.each_index do |i|
      return false unless node = node[array[i]]
      if node[:end] && find(array[i+1..-1], false)
        puts "#{array[0..i].join} + #{array[i+1..-1]}"
        return true 
      end
    end
    node[:end] && !original
  end
end

class Task
  # Parse a file or stream, build a prefix tree
  # and find longest words that can be built from shorter
  # words in word list

  def initialize(stream = nil)
    # Provide optional stream to read words from
    # It will use 'words for problem.txt' file by default

    words = stream || File.read('words for problem.txt')
    @tree = PrefixTree.new
    hash = Hash.new { |hash, key| hash[key] = [] }
    words.each_line do |w|
      word = w.chomp
      unless word.empty?
        @tree.build(word) 
        hash[word.size] << word
      end
    end
    @sorted_words = hash.keys.sort {|a,b| b <=> a }.inject([]) {|arr, n| arr + hash[n]}
  end

  def solve(count)
    # Provide quantity of longest words you would like to search
    # Returns an array of longest words from word list that
    # can be build using shorter ones

    result = []
    @sorted_words.each do |word|
      result << word if @tree.find(word.split(''), true)
      break if result.size == count
    end
    result
  end
end
task = Task.new
puts task.solve(2)