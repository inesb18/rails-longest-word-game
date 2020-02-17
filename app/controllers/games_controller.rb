require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @start_time = params[:start_time]
    @letters = params[:letters_as_string].split(" ")
    url = "http://wagon-dictionary.herokuapp.com/#{@word.downcase}"
    word_serialized = open(url).read
    word_in_dictionary = JSON.parse(word_serialized)
    @existing = word_in_dictionary["found"]
    @in_the_grid = @word.upcase.chars.all? { |letter| @word.upcase.count(letter) <= @letters.count(letter) }
  end
end
