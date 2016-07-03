require './deck.rb'

class Shoe

  attr_accessor :shoe

  def initialize
    @shoe = []
    create_shoe
    @shoe.shuffle!
  end

  def create_shoe
    7.times { self.shoe +=  Deck.new.deck }
  end

  def deal_hand
    shoe.shift(2)
  end

  def plus_1
    shoe.shift(1)
  end

end
