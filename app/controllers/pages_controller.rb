require 'open-uri'
require 'json'

class PagesController < ApplicationController
  VOWELS = %w(A E I O U Y)
  def home
    @grid_size = rand(5...8)
    @grid = Array.new(5) { VOWELS.sample }
    @grid += Array.new(@grid_size) { (("A".."Z").to_a - VOWELS).sample }
    @grid.shuffle!
  end

  def score
    @grid = params[:grid].split
    @user_word = (params[:word] || "").upcase
    @result = check_word(@user_word, @grid)
  end

  def check_word(word, grid)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    file_read = URI.open(url).read
    words = JSON.parse(file_read)
    check = word.upcase
    letters = check.chars
    @score = 0
    if words["found"] == true && (letters - grid).empty?
      "Well done, you scored #{@score += word.length} points"
    elsif words["found"] == false
      "Not an english word, try again! you scored #{@score} points"
    else
      "You must use the letters in the grid only, you scored #{@score} points"
    end
  end

end
