#!/usr/bin/env ruby

# Define Gems
require 'rubygems'
require 'pry'

# Define Classes
class Card
  attr_accessor :suit, :value

  def initialize(suit, value)
    @suit = suit 
    @value = value
  end

  def pretty_output
    "#{value} of #{find_suit}"
  end

  def to_s
    pretty_output
  end

  def find_suit
     case suit
       when 'H' then 'Hearts'
       when 'D' then 'Diamonds'
       when 'S' then 'Spades'
       when 'C' then 'Clubs'
     end
  end
end

class Deck
  attr_accessor :cards

  def initialize
    #suits = ['Spades', 'Clubs', 'Hearts', 'Diamonds']
    #value = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
    #@cards = []
    #@cards = suits.product(value)
    
    @cards = []
    suits = ['H', 'D', 'S', 'C'].each do |suit|
      value = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |value|
        @cards << Card.new(suit, value)
      end
    end
   end

  def shuffle
    puts ""
    puts "Shuffling and dealing cards..."
    cards.shuffle!
    sleep 1
  end

  def deal_one
    cards.pop
  end
end

# Define Modules
module Hand
  def show_hand
    puts "-----#{name}'s Hand"
    cards.each do |card| 
      puts "#{card}"
    end
    puts "=> Total: #{total}"
    puts ""
  end

  def total
    # Get card value from the second element [1] and put into new array
    temp_array = cards.map {|card| card.value}

    # Loop through the temp array and calculate card total
    card_total = 0
    temp_array.each do |value|
      if value == "A"
        card_total += 11
      elsif value.to_i == 0 # J, Q, K
        card_total += 10
      else
        card_total += value.to_i
      end
    end

    # If total is greater than 21 & the card is an ace, set ace value 1
    temp_array.select{|e| e == "A"}.count.times do
      card_total -= 10 if card_total > 21
    end

    # Return card total
    card_total
  end

  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total > 21
  end
end

# Define Classes
class Player
  include Hand

  attr_accessor :name, :cards

  def initialize
    puts '/         \ /         \ '
    puts '|J        | |A        |'
    puts '|    ,    | |   _ _   |'
    puts '|   / \   | |  / ^ \  |'
    puts '|  (_ _)  | |  \   /  |'
    puts '|   /_\   | |   \ /   |'
    puts '|         | |    `    |'
    puts '|        J| |        A|'
    puts '\_________/ \_________/'

    puts ""
    puts "Welcome to blackjack. What is your name?"
    @name = gets.chomp
    @cards = []
  end

  def show_flop
    show_hand
  end

  #def starting_account
  #  puts ""
  #  puts "Please enter the amount of money you are starting with #{name}:"
  #  @starting_account_total = gets.chomp
  #end
end

class Dealer
  include Hand

  attr_accessor :cards, :name

  def initialize
    @name = "Dealer"
    @cards = []
  end

  def show_flop
    puts "-----#{name}'s Hand"
    puts "=> First card is hidden"
    puts "=> Second card is #{cards[1]}"
  end
end

class Blackjack
  attr_accessor :deck, :player, :dealer

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
    deck.shuffle
  end

  def deal_cards
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)

    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end

  def show_flop
    player.show_flop
    dealer.show_flop
  end

  def show_hands
    player.show_hand
    dealer.show_hand
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.total == 21
      if player_or_dealer.is_a?(Dealer)
        puts "Sorry, dealer hit blackjack. #{player.name} loses."
      else
        puts "Congratulations #{player.name}, you hit blackjack."
      end
      play_again?
    elsif player_or_dealer.is_busted?
      if player_or_dealer.is_a?(Dealer)
        puts "Congratulations #{player.name}, dealer busted. You win."
      else
        puts "Sorry, #{player.name}, you busted. You lose."
      end
      play_again?
    end
  end  

  def player_turn
    puts ""
    puts "#{player.name}'s turn."

    # Check to see if player hit blackjack
    blackjack_or_bust?(player)

    while !player.is_busted?
      puts "What would you like to do? 1) hit 2) stay"
      hit_or_stay = gets.chomp

      # Incorrect response
      (puts "Error: you must enter 1 or 2"; next) if !['1', '2'].include?(hit_or_stay)

      # Player stay
      (puts "#{player.name} stays at #{player.total}."; break;) if hit_or_stay == "2"

      # Player hit
      new_card = deck.deal_one
      puts "Dealing card to #{player.name}: #{new_card}"

      # Add card to players hand
      player.add_card(new_card)
   
      # Hit
      puts "#{player.name}'s total is now: #{player.total}"

      # Check to see if player hit blackjack or bust
      blackjack_or_bust?(player)
    end
  end

  def dealer_turn
    puts ""
    puts "#{dealer.name}'s turn."

    # Check to see if dealer hit blackjack
    blackjack_or_bust?(dealer)

    while dealer.total < 17
      # Hit
      new_card = deck.deal_one
      puts "Dealing card to #{dealer.name}: #{new_card}"

      # Dealer hit
      dealer.add_card(new_card)

      blackjack_or_bust?(dealer)
    end
    # Dealer stays - total between 17 and 20
    puts "Dealer stays at #{dealer.total}."
  end

  def who_won?(player, dealer)
    #puts "Congratulations, #{player.name}, you win." if player.total > dealer.total
    #puts "Sorry #{player.name}, you lose." if player.total < dealer.total
    #puts "It's a tie." if player.total = dealer.total
    if player.total > dealer.total
      "Congratulations, #{player.name}, you win."
    elsif player.total < dealer.total
      puts "Sorry #{player.name}, you lose."
    else
      puts "It's a tie."
    end
    play_again?
  end

  def play_again?
    puts "Would you like to play again? 1) yes; 2) no;"
    if gets.chomp == '1'
      puts "Starting new game..."
      puts ""
      deck = Deck.new
      player.cards = []
      dealer.cards = []
      start
    else
      puts "Thanks for playing #{player.name}!"
      exit
    end  
  end

  def start
    deal_cards
    show_flop
    player_turn
    dealer_turn
    who_won?(player, dealer)
  end
end


# Runtime
game = Blackjack.new
game.start