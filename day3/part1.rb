wire_paths = []

File.open("./input.txt", "r") do |f|
  f.each_line do |line|
    wire_paths << line
  end
end

def move_wire(instruction, current_position)
  direction = instruction[0]
  value = instruction[1..-1].to_i

  x = current_position[:x]
  y = current_position[:y]

  path_positions = []

  case direction
  when 'L'
    i = x
    goal_x = x - value
    while i >= goal_x do
      path_positions << { x: i, y: y }
      i -= 1
    end
  when 'U'
    i = y
    goal_y = y + value
    while i <= goal_y do
      path_positions << { x: x, y: i }
      i += 1
    end
  when 'R'
    i = x
    goal_x = x + value
    while i <= goal_x do
      path_positions << { x: i, y: y }
      i += 1
    end
  else
    i = y
    goal_y = y - value
    while i >= goal_y do
      path_positions << { x: x, y: i }
      i -= 1
    end
  end

  path_positions
end


all_path_coordinates = []

wire_paths.each do |paths|
  coordinates_for_path = [{ x: 0, y: 0 }]

  paths.split(',').each do |move|
    coordinates_for_path.concat move_wire(move, coordinates_for_path.last)
  end

  all_path_coordinates << coordinates_for_path
end

common_coordinates = all_path_coordinates.reduce(:&)

closest_coords = {}
min_distance = 2**30 - 1

common_coordinates.each do |coord|
  next if coord[:x] == 0 && coord[:y] == 0
  manhattan_distance = coord[:x].abs + coord[:y].abs

  if manhattan_distance < min_distance
    min_distance = manhattan_distance
    closest_coords = coord
  end
end

puts closest_coords, min_distance
