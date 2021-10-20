require 'open-uri'
require 'json'

class GamesController < ApplicationController
  before_action :set_letters, only: [:new]

  def new
    set_letters
  end

  def score
    @word = params[:word].upcase
    @display_message = if check_letters?(@word, @letters)
      "Sorry but #{@word} can't be built out of #{@letters.join}."
    elsif real_word?(@word) 
      "Congratulations! #{@word} is a valid English word!"
    else
      "Sorry by #{@word} does not seem to be a valid English word..."
    end
  end

  private 

  def check_letters?(word, letters)
    letters_count = Hash.new(0)
    letters.each { |ch| letters_count[ch] += 1 }
    word.upcase.each_char { |ch| letters_count[ch] -= 1 }
    letters_count.values.any? { |count| count.negative? }
  end

  def real_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = URI.open(url).read
    JSON.parse(word_serialized)["found"]
  end

  def set_letters
    albhabet = ("A".."Z").to_a
    @letters ||= Array.new(10) { albhabet.sample } 
  end
end
