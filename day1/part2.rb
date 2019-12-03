@modules_mass = []

File.open("./input.txt", "r") do |f|
  f.each_line do |line|
    @modules_mass << line.to_i
  end
end

def module_fuel(mass)
  (mass / 3).floor - 2
end

def fuel_total_for_fuel_mass(fuel_mass)
  fuel_for_mass = module_fuel(fuel_mass)
  return 0 unless fuel_for_mass > 0

  fuel_for_mass += fuel_total_for_fuel_mass(fuel_for_mass)
end

@modules_fuel = @modules_mass.map do |module_mass|
  fuel_for_base_module = module_fuel(module_mass)
  total_fuel_for_module_fuel = fuel_total_for_fuel_mass(fuel_for_base_module)

  fuel_for_base_module + total_fuel_for_module_fuel
end

puts @modules_fuel.reduce(:+)
