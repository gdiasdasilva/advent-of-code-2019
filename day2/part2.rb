File.open("./input.txt", "r") do |f|
  f.each_line do |line|
    @integers = line.split(',')
  end
end

@integers = @integers.map(&:to_i).freeze

def calculate(integers_list, noun, verb)
  integers_list[1] = noun
  integers_list[2] = verb

  i = 0

  while i < integers_list.length do
    operator_value = integers_list[i]

    break if operator_value == 99

    first_input_index = integers_list[i+1]
    second_input_index = integers_list[i+2]
    output_index = integers_list[i+3]

    first_value = integers_list[first_input_index]
    second_value = integers_list[second_input_index]

    if operator_value == 1
      integers_list[output_index] = first_value + second_value
    elsif operator_value == 2
      integers_list[output_index] = first_value * second_value
    end

    i += 4
  end

  integers_list[0]
end

for noun in 0..99 do
  for verb in 0..99 do
    a = @integers
    total = calculate(a.dup, noun, verb)

    if total == 19690720
      @noun = noun
      @verb = verb
      break
    end
  end
end

puts "noun: #{@noun}, verb: #{@verb}; 100 * #{@noun} + #{@verb} = #{100 * @noun + @verb}"
