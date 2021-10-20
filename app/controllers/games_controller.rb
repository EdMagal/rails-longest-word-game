require 'open-uri'
require 'json'

class GamesController < ApplicationController
  VOWELS = %w(A E I O U)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @word = (params[:word] || "").upcase
    @letters = params[:letters].split
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
end
