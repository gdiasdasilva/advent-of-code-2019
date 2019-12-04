wire_paths = []

File.open('./input.txt', 'r') do |f|
  f.each_line do |line|
    wire_paths << line
  end
end

def move_wire(instruction, current_position, common_coords = [], acc_cost = 0)
  direction = instruction[0]
  value = instruction[1..-1].to_i

  x = current_position[:x]
  y = current_position[:y]

  path_positions = []

  cost = 0
  intersections_with_cost = []

  case direction
  when 'L'
    i = x
    cost = value

    goal_x = x - value
    while i >= goal_x do
      tmp_cost = acc_cost + (i - x).abs
      new_tmp_position = { x: i, y: y }
      path_positions << new_tmp_position
      i -= 1

      if common_coords.include? new_tmp_position
        intersections_with_cost << { position: new_tmp_position, move_cost: tmp_cost }
      end
    end
  when 'U'
    i = y
    cost = value

    goal_y = y + value
    while i <= goal_y do
      new_tmp_position = { x: x, y: i }
      tmp_cost = acc_cost + (i - y).abs
      path_positions << new_tmp_position
      i += 1

      if common_coords.include? new_tmp_position
        intersections_with_cost << { position: new_tmp_position, move_cost: tmp_cost }
      end
    end
  when 'R'
    i = x
    cost = value

    goal_x = x + value
    while i <= goal_x do
      tmp_cost = acc_cost + (i - x).abs
      new_tmp_position = { x: i, y: y }
      path_positions << new_tmp_position
      i += 1

      if common_coords.include? new_tmp_position
        intersections_with_cost << { position: new_tmp_position, move_cost: tmp_cost }
      end
    end
  else
    i = y
    cost = value

    goal_y = y - value
    while i >= goal_y do
      tmp_cost = acc_cost + (i - y).abs
      new_tmp_position = { x: x, y: i }
      path_positions << new_tmp_position
      i -= 1

      if common_coords.include? new_tmp_position
        intersections_with_cost << { position: new_tmp_position, move_cost: tmp_cost }
      end
    end
  end

  {
    path_positions: path_positions,
    intersections_with_cost: intersections_with_cost,
    cost: cost
  }
end

all_path_coordinates = []

wire_paths.each do |paths|
  coordinates_for_path = [{ x: 0, y: 0 }]

  paths.split(',').each do |move|
    coordinates_for_path.concat move_wire(move, coordinates_for_path.last)[:path_positions]
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
    move_data = move_wire(move, coordinates_for_path.last, common_coordinates, acc_cost)

    acc_cost += move_data[:cost]
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
    next if first_intersection[:position] != second_intersection[:position] ||
            first_intersection[:position][:x] == 0 && first_intersection[:position][:y] == 0 ||
            second_intersection[:position][:x] == 0 && second_intersection[:position][:y] == 0

    sum = first_intersection[:move_cost] + second_intersection[:move_cost]
    minimum_sum = sum if minimum_sum > sum
  end
end

puts minimum_sum
