File.open("./input.txt", "r") do |f|
  f.each_line do |line|
    @integers = line.split(',')
  end
end

@integers = @integers.map(&:to_i)

# problem setup
@integers[1] = 12
@integers[2] = 2

i = 0

while i < @integers.length do
  operator_value = @integers[i]

  break if operator_value == 99

  first_input_index = @integers[i+1]
  second_input_index = @integers[i+2]
  output_index = @integers[i+3]

  first_value = @integers[first_input_index]
  second_value = @integers[second_input_index]

  if operator_value == 1
    @integers[output_index] = first_value + second_value
  elsif operator_value == 2
    @integers[output_index] = first_value * second_value
  end

  i += 4
end

puts @integers[0]
