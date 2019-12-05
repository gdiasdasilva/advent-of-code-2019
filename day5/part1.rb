require 'byebug'

integers_input = []

File.open("./input.txt", "r") do |f|
  f.each_line do |line|
    integers_input = line.split(',').map(&:to_i)
  end
end

def calculate(integers_list)
  i = 0

  while i < integers_list.length
    operator_value = integers_list[i]

    break if operator_value == 99

    case operator_value
    when 1
      first_input_index = integers_list[i+1]
      second_input_index = integers_list[i+2]
      output_index = integers_list[i+3]

      first_value = integers_list[first_input_index]
      second_value = integers_list[second_input_index]

      integers_list[output_index] = first_value + second_value
    when 2
      first_input_index = integers_list[i+1]
      second_input_index = integers_list[i+2]
      output_index = integers_list[i+3]

      first_value = integers_list[first_input_index]
      second_value = integers_list[second_input_index]

      integers_list[output_index] = first_value * second_value
    when 3
      param = integers_list[i+1]
      integers_list[param] = param
      byebug
    end

    i += 4
  end

  integers_list[0]
end

calculate([3,4,0,0,0,0])
