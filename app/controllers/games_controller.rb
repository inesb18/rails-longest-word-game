require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    # pry-byebug
    @total_score = session[:total_score] || 0
    @word = params[:word]
    @start_time = params[:start_time]
    elapsed_time = Time.now - @start_time.to_time
    @score = @word.length * 100 / elapsed_time.to_i
    @letters = params[:letters_as_string].split(" ")
    url = "http://wagon-dictionary.herokuapp.com/#{@word.downcase}"
    word_serialized = open(url).read
    word_in_dictionary = JSON.parse(word_serialized)
    @existing = word_in_dictionary["found"]
    @in_the_grid = @word.upcase.chars.all? { |letter| @word.upcase.count(letter) <= @letters.count(letter) }
    if @existing && @in_the_grid
      @total_score += @score
      session[:total_score] = @total_score
    end
  end
end
