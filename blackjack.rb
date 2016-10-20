require './card.rb'
require './deck.rb'

class Game

  attr_accessor :game_deck, :player_hand, :dealer_hand

  def initialize
    @game_deck = Deck.new
    @player_hand = []
    @dealer_hand = []
  end

  def play(say_intro=true)
    intro if say_intro
    deal
    blackjack(player_hand)
    blackjack(dealer_hand)
    hit_stay
    dealer_reveal
    dealer_hit_stay
    determine_winner
  end

  def intro
    puts "Hi there, welcome to Blackjack. Nearest to 21 without going over wins, dealer stays on 16 or higher"
    puts "Ready to go?"
    gets
  end

  def deal
    puts "-----------------------------------------------------"
    self.player_hand += game_deck.deal_hand
    self.dealer_hand += game_deck.deal_hand
    puts "You were dealt the #{player_hand[0]} and the #{player_hand[1]}"
    puts "Your card total is #{total_value(player_hand)}"
    bust(player_hand)
    puts "Dealer shows the #{dealer_hand[0]}"
    bust(dealer_hand)
  end

  def total_value(hand)
    hand.inject(0){|sum, cards| sum += cards.value }
  end

  def hit_stay
    puts "Sorry, you busted #{rematch}" if bust(player_hand)
    puts "Would you like to hit (plus 1 card) or stay where you are?" if !bust(player_hand)
      resp = gets.chomp&.downcase[0]
        until resp == "s" || bust(player_hand) || total_value(player_hand) == 21
          self.player_hand += game_deck.hit
          puts "You were dealt the #{player_hand[-1]}"
          puts "You now sit at #{total_value(player_hand)}"
          puts "Would you like to hit or stay?" if !bust(player_hand) && total_value(player_hand) < 21
          puts "Sorry, you busted" if bust(player_hand)
          resp = gets.chomp&.downcase[0] unless total_value(player_hand) >= 21
        end
  end

  def dealer_reveal
    puts "Dealer reveals the #{dealer_hand[1]} for a total of #{total_value(dealer_hand)}"
  end

  def dealer_hit_stay
    until total_value(dealer_hand) >= 16
      self.dealer_hand += game_deck.hit
      puts "Dealer draws a #{dealer_hand[-1]} for a new total of #{total_value(dealer_hand)}"
    end
    bust(dealer_hand)
  end

  def determine_winner
    if total_value(dealer_hand) > 21 || total_value(player_hand) > total_value(dealer_hand) && total_value(player_hand) < 22
      puts "You win!"
    elsif total_value(player_hand) > 21 || total_value(player_hand) < total_value(dealer_hand) && total_value(dealer_hand) < 22
      puts "Dealer wins!"
    else
      puts "It's a push"
    end
    rematch
  end

  def bust(hand)
    if total_value(hand) > 21
      true
      puts "You Busted!"
      determine_winner
    else
      false
    end
  end

  def blackjack(hand)
    if self.total_value(hand) == 21
      dealer_reveal
      puts "Blackjack!"
      determine_winner
    end
  end

  def rematch
    puts "Play another hand? Y/N."
    resp = gets.chomp&.upcase[0]
    if resp == "Y"
      Game.new.play(false)
    else
      puts "Thank you for playing."
      exit
    end
  end

end

  Game.new.play
