wire_paths = []

File.open('./input.txt', 'r') do |f|
  f.each_line do |line|
    wire_paths << line
  end
end

def process_instruction(instruction, current_position, known_intersections = [], acc_cost = 0)
  direction = instruction[0]
  value = instruction[1..-1].to_i

  move_result = move_until_goal(
    { x: current_position[:x], y: current_position[:y] },
    direction,
    value,
    acc_cost,
    known_intersections
  )

  {
    path_positions: move_result[:points_transversed],
    intersections_with_cost: move_result[:intersections_acc_cost],
    instruction_cost: value
  }
end

def move_until_goal(start_coords, direction, value_to_move, accumulated_cost, known_intersections)
  points_transversed = []
  intersections_with_cost = []

  case direction
  when 'L'
    changing_coord_symbol = :x
    direction_multiplier = -1
  when 'U'
    changing_coord_symbol = :y
    direction_multiplier = 1
  when 'R'
    changing_coord_symbol = :x
    direction_multiplier = 1
  else
    changing_coord_symbol = :y
    direction_multiplier = -1
  end

  fixed_coord_symbol = changing_coord_symbol == :x ? :y : :x

  initial_value = start_coords[changing_coord_symbol]
  goal_value = initial_value + (value_to_move * direction_multiplier)

  current_position_value = initial_value
  should_continue = true

  while should_continue
    should_continue = if direction_multiplier == -1
                        current_position_value > goal_value
                      else
                        current_position_value < goal_value
                      end

    total_cost = accumulated_cost + (current_position_value - initial_value).abs

    new_position = {}
    new_position[changing_coord_symbol] = current_position_value
    new_position[fixed_coord_symbol] = start_coords[fixed_coord_symbol]

    points_transversed << new_position
    current_position_value += (1 * direction_multiplier)

    next unless known_intersections.include? new_position

    intersections_with_cost << { position: new_position, move_cost: total_cost }
  end

  {
    points_transversed: points_transversed,
    intersections_acc_cost: intersections_with_cost
  }
end

all_path_coordinates = []

wire_paths.each do |paths|
  coordinates_for_path = [{ x: 0, y: 0 }]

  paths.split(',').each do |move|
    coordinates_for_path.concat(
      process_instruction(move, coordinates_for_path.last)[:path_positions]
    )
  end

  all_path_coordinates << coordinates_for_path
end

common_coordinates = all_path_coordinates.reduce(:&)

all_intersections_coordinates = []

wire_paths.each do |paths|
  coordinates_for_path = [{ x: 0, y: 0 }]
  intersections_with_cost_for_path = []
  acc_cost = 0

  paths.split(',').each do |move|
    move_data = process_instruction(move, coordinates_for_path.last, common_coordinates, acc_cost)

    acc_cost += move_data[:instruction_cost]
    coordinates_for_path.concat move_data[:path_positions]

    unless move_data[:intersections_with_cost].empty?
      intersections_with_cost_for_path << move_data[:intersections_with_cost]
    end
  end

  all_intersections_coordinates << intersections_with_cost_for_path.flatten
end

minimum_sum = 2**30 - 1

all_intersections_coordinates.first.each do |first_intersection|
  all_intersections_coordinates.last.each do |second_intersection|
    next if first_intersection[:position] != second_intersection[:position]
    next if first_intersection[:position][:x].zero? && first_intersection[:position][:y].zero?
    next if second_intersection[:position][:x].zero? && second_intersection[:position][:y].zero?

    sum = first_intersection[:move_cost] + second_intersection[:move_cost]
    minimum_sum = sum if minimum_sum > sum
  end
end

puts minimum_sum
