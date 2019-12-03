@modules_mass = []

File.open("./input.txt", "r") do |f|
  f.each_line do |line|
    @modules_mass << line.to_i
  end
end

def module_fuel(mass)
  (mass / 3).floor - 2
end

puts @modules_mass.reduce(0) { |total, module_mass| total += module_fuel(module_mass) }
