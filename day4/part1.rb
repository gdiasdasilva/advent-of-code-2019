input = '387638-919123'

lower_bound = input.split('-')[0].to_i
upper_bound = input.split('-')[1].to_i

def valid?(number)
  number_string = number.to_s
  has_same_adjacent_digits = false

  (0..number_string.length - 1).each do |i|
    return false if i.positive? && number_string[i] < number_string[i - 1]

    has_same_adjacent_digits = true if number_string[i] == number_string[i - 1]
  end

  has_same_adjacent_digits
end

valid_count = 0

(lower_bound..upper_bound).each do |number|
  valid_count += 1 if valid?(number)
end

puts valid_count
