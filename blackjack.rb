require './card.rb'
require './deck.rb'
require './shoe.rb'

class Game

  attr_accessor :game_deck, :player_hand, :dealer_hand

  def initialize
    @game_deck = Shoe.new
    @player_hand = []
    @dealer_hand = []
  end

  def play(say_intro=true)
    intro if say_intro
    deal
    check_blackjack
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
    if !bust(player_hand) && !score_21(player_hand)
      puts "Would you like to hit (plus 1 card) or stay where you are?"
      resp = gets.chomp&.downcase[0]
    end
    until resp == "s" || bust(player_hand) || score_21(player_hand)
      self.player_hand += game_deck.plus_1
      puts "You were dealt the #{player_hand[-1]}"
      puts "You now sit at #{total_value(player_hand)}"
      puts "Would you like to hit or stay?" if !busted(player_hand)
      resp = gets.chomp&.downcase[0] if !busted(player_hand) && !score_21(player_hand)
    end
  end

  def dealer_reveal
    puts "Dealer reveals the #{dealer_hand[1]} for a total of #{total_value(dealer_hand)}"
  end

  def dealer_hit_stay
    until total_value(dealer_hand) >= 16
      self.dealer_hand += game_deck.plus_1
      puts "Dealer draws the #{dealer_hand[-1]} for a total of #{total_value(dealer_hand)}"
    end
    bust(dealer_hand)
  end

  def bust(hand)
    if total_value(hand) > 21
      true
      puts "Bust!"
      determine_winner
    else
      false
    end
  end

  def busted(hand)
    total_value(hand) > 21
  end

  def score_21(hand)
    total_value(hand) == 21
  end

  def win_condition(hand1, hand2)
    hand1.length >= 6 && total_value(hand1) <= 21 || total_value(hand1) > total_value(hand2) && !busted(hand1)
  end

  def tied_hand(hand1, hand2)
    hand1.length > hand2.length && total_value(hand1) == total_value(hand2)
  end

  def blackjack(hand)
    if self.total_value(hand) == 21
      dealer_reveal
      puts "Blackjack!"
      determine_winner
    end
  end

  def determine_winner
    if busted(dealer_hand) || win_condition(player_hand, dealer_hand) || tied_hand(player_hand, dealer_hand)
      puts "You win!"
    elsif busted(player_hand) || win_condition(dealer_hand, player_hand) || tied_hand(dealer_hand, player_hand)
      puts "Dealer wins!"
    else
      puts "It's a push"
    end
    rematch
  end

  def check_blackjack
    blackjack(player_hand)
    blackjack(dealer_hand)
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
