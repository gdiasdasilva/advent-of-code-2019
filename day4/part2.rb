input = '387638-919123'

lower_bound = input.split('-')[0].to_i
upper_bound = input.split('-')[1].to_i

def valid?(number)
  number_string = number.to_s

  has_two_adjacent_digits = false
  same_adjacent_digits_count = 1

  (0..number_string.length - 1).each do |i|
    current_digit = number_string[i]
    previous_digit = number_string[i - 1] if i.positive?
    is_last_digit = (i == number_string.length - 1)

    return false if !previous_digit.nil? && current_digit < previous_digit

    same_adjacent_digits_count += 1 if current_digit == previous_digit

    if (current_digit != previous_digit || is_last_digit) && same_adjacent_digits_count == 2
      has_two_adjacent_digits = true
    end

    same_adjacent_digits_count = 1 if current_digit != previous_digit
  end

  has_two_adjacent_digits
end

result = (lower_bound..upper_bound).reduce(0) do |valid_count, number|
  valid?(number) ? valid_count + 1 : valid_count
end

puts "# of different passwords: #{result}"
