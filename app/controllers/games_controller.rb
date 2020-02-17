require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def reset
    reset_session
    redirect_to new_path
  end

  def new
    @letters = generate_grid(10)
  end

  def score
    # pry-byebug
    @total_score = session[:total_score] || 0
    @word = params[:word]
    @start_time = params[:start_time]
    @letters = params[:letters_as_string].split(" ")
    @existing = existing?(@word)
    @in_the_grid = in_the_grid?(@word, @letters)
    if @existing && @in_the_grid
      @score = compute_score(@word, @start_time.to_time, Time.now)
      @total_score += @score
      session[:total_score] = @total_score
    end
  end

  private

  def generate_grid(grid_size)
    grid = []
    grid_size.times { grid << ('A'..'Z').to_a.sample }
    return grid
  end

  def existing?(word)
    url = "http://wagon-dictionary.herokuapp.com/#{word.downcase}"
    word_serialized = open(url).read
    word_in_dictionary = JSON.parse(word_serialized)
    return word_in_dictionary["found"]
  end

  def in_the_grid?(word, grid)
    # checks whether every letter appears in the grid
    # (each letter of the grid can only be used once)
    return word.upcase.chars.all? { |letter| word.upcase.count(letter) <= grid.count(letter) }
  end

  def compute_score(attempt, start_time, end_time)
    # returns the score
    return (attempt.length * 100 / (end_time - start_time)).to_i
  end

end
