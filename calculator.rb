#!/usr/bin/env ruby

# Get user input and store variable to number
puts "Welcome to my calculator. Please enter the first number:"
num1 = gets.chomp
num1 = num1.to_i

# Get user input and store variable to number
puts "Please enter the second number:"
num2 = gets.chomp
num2 = num2.to_i

# Select the operator
puts "Please choose an operation: 1)add; 2)subtract; 3)multiply; 4)divide;"
operator = gets.chomp

# Define result
result = nil

# Evaluate expression and store to result
if operator == '1'
  result = num1 + num2
elsif operator == '2'
  result = num1 - num2
elsif operator == '3'
  result = num1 * num2
elsif operator == '4'
  result = num1.to_f / num2.to_f
end

# Print result
puts "Result: #{result}"
