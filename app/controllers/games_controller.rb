require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ('a'..'z').to_a
    @letters = []

    10.times do
      @letters << alphabet.sample
    end
  end

  def score
    @word = params['guess']
    @game_letters = params['game_letters'].split(' ')

    @good = word_use_letters?(@word, @game_letters)
    @english = word_is_english?(@word)
    @score = calculate_score(@word)
  end

  private

  def word_use_letters?(word, game_letters)
    check_letters = game_letters.dup
    word.chars.each do |letter|
      return false unless check_letters.include?(letter)

      check_letters.delete_at(check_letters.index(letter))
    end
    true
  end

  def word_is_english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = URI.open(url).read
    data = JSON.parse(response)

    data['found']
  end

  def calculate_score(word)
    word.length * 10
  end
end
