require './card.rb'

class Deck

  attr_accessor :deck

  def initialize
    @deck = []
    create_deck
    @deck.shuffle!
  end

  def create_deck
    face_name = %w(2 3 4 5 6 7 8 9 10 J Q K A)
    suit_name = %w(Hearts Diamonds Clubs Spades)
    suit_name.each do |x|
      face_name.each do |y|
        self.deck << Card.new( y, x)
      end
    end
  end

  def deal_hand
    deck.shift(2)
  end

  def plus_1
    deck.shift(1)
  end

end
