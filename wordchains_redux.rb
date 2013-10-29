require "debugger"

class WordChains
  attr_accessor :word_list

  WordStep = Struct.new(:word, :prev)

  def initialize
    @word_list = File.readlines("dictionary.txt").map(&:chomp)
  end

  def create_adjacent_combinations(word)
    adjacent_words = []

    word.length.times do |index|
      ("a".."z").each do |letter|
        next if letter == word[index]

        next_word = word.dup
        next_word[index] = letter
        adjacent_words << next_word
      end
    end

    adjacent_words
  end

  def find_adjacent_words(words)
    words.select { |word| word_list.include?(word) }
  end

  def print_path(visited_words, word)
    return [word] if visited_words[word] == true
    [word] + print_path(visited_words, visited_words[word])
  end

  def build_path(word_step)
    return [word_step.word] if word_step.prev.nil?

    [word_step.word] + build_path(word_step.prev)
  end

  def find_chain(start_word, end_word)
    #attempts to use a struct
    self.word_list = word_list.select { |word| word.length == start_word.length }

    first_step = WordStep.new(start_word, nil)
    next_words = [first_step]
    visited_words = [start_word]

    until next_words.empty?
      current_step = next_words.shift

      word_combinations = create_adjacent_combinations(current_step.word)
      valid_words = find_adjacent_words(word_combinations)
      valid_words = valid_words.select { |w| !visited_words.include?(w) }

      #p current_step.word
      valid_words.each do |word|
        next_step = WordStep.new(word, current_step)
        visited_words << word
        #p word
        if word == end_word
          return build_path(next_step)
        end

        next_words << next_step
      end
    end

  end

  def find_chain_hash(start_word, end_word)
    self.word_list = word_list.select { |word| word.length == start_word.length }

    next_words = [start_word]
    visited_words = { start_word => true }

    until next_words.empty?
      word = next_words.shift

      word_combinations = create_adjacent_combinations(word)
      valid_words = find_adjacent_words(word_combinations)
      valid_words = valid_words.select { |w| !visited_words.keys.include?(w) }

      valid_words.each { |new_word| visited_words[new_word] = word }

      return print_path(visited_words, end_word) if visited_words[end_word]

      next_words += valid_words
    end
  end
end

word_chain = WordChains.new
p word_chain.find_chain("duck","ruby")