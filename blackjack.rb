#!/usr/bin/env ruby

# Calculate Cards Method
def calculate_total(cards)
  # Get card value from the second element [1] and put into new array
  temp_array = cards.map {|card_value| card_value[1]}

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

# Welcome banner
puts "Welcome to the best blackjack table in Vegas. High rollers only. What's your name chap?" 

# Get player name
player_name = gets.chomp
player_name

puts ""
puts "Welcome #{player_name}."
print "Shuffling cards..."
sleep 1;
puts " Dealing cards..."
sleep 1;
puts ""

# Define arrays for cards
suits = ['Spades', 'Clubs', 'Hearts', 'Diamonds']
cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

# Setup the card deck by nesting arrays and shuffling the deck
deck = suits.product(cards)
deck.shuffle!

# Deal Cards
player_cards = []
dealer_cards = []

player_cards << deck.pop
dealer_cards << deck.pop
player_cards << deck.pop
dealer_cards << deck.pop

# Calculate card totals
dealer_total = calculate_total(dealer_cards)
player_total = calculate_total(player_cards)

# Show cards
puts "Dealer has: #{dealer_cards[0]} & #{dealer_cards[1]}"
puts "Total: #{dealer_total}"
puts "#{player_name} has: #{player_cards[0]} & #{player_cards[1]}"
puts "Total: #{player_total}"
puts ""

# If player has 21, game over
player_total == 21 ? (puts "#{player }, you won! You hit blackjack!"; exit) :

# Check to see if player would like to hit or stay
while player_total < 21
  puts "What would you like to do? 1) hit 2) stay"
  hit_or_stay = gets.chomp

  # Incorrect response
  (puts "Error: you must enter 1 or 2"; next) if !['1', '2'].include?(hit_or_stay)

  # Player Stay
  (puts "You chose to stay"; break;) if hit_or_stay == "2"

  # Player hit
  new_card = deck.pop
  puts "Dealing card to player: #{new_card}"
  player_cards << new_card
  player_total = calculate_total(player_cards)
  puts "Total: #{player_total}"
  
  # If player hit is 21 or goes over 21
  (puts "Congratulations, you hit blackjack. You win!"; exit) if player_total == 21
  (puts "You busted #{player_name}. You lose!"; exit) if player_total > 21
end

# Dealer turn
dealer_total == 21 ? (puts "Sorry, dealer hit blackjack. You lose!"; exit) :

while dealer_total < 17
  # Hit
  new_card = deck.pop
  puts "Dealing new card for dealer: #{new_card}"
  dealer_cards << new_card
  dealer_total = calculate_total(dealer_cards)
  puts "Dealer total is now: #{dealer_total}"

  # If dealer hits 21 or goes over 21
  dealer_total == 21 ? (puts "Sorry, dealer hit blackjack. You lose!"; exit) : ()
  dealer_total > 21 ? (puts "Dealer busted! You win!"; exit) : ()
end

# Compare hands
puts "Dealer's cards: "
dealer_cards.each do |card|
  puts "=> #{card}"
end
puts ""

puts "Your cards:"
player_cards.each do |card|
  puts "=> #{card}"
end
puts ""

if dealer_total > player_total
  puts "Sorry, dealer wins."
elsif dealer_total < player_total
  puts "Congratulations, you win!"
else
  puts "It's a tie!"
end

exit
