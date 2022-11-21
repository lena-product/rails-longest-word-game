require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []
    until @letters.size == 10
      letter = ('A'..'Z').to_a.sample
      @letters << letter
    end
  end

  def score
    @guess = params[:guess].upcase
    @letters = params[:letters]
    @message = "Sorry but #{@guess} can't be built out of #{@letters.split.join(", ")}"

    if included(@guess, @letters)
      if dictionary(@guess)
        @message = "Congratulations! #{@guess} is a valid English word!"
      else @message = "Sorry but #{@guess} does not seem to be a valid English word."
      end
    else @message = "Sorry but #{@guess} does not seem to be a valid English word."
    end
  end

  def dictionary(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    check = JSON.parse(URI.open(url).read)
    return check["found"]
  end

  def included(guess, letters)
    guess.chars.all? { |letter| guess.count(letter) <= letters.count(letter) }
  end
end
