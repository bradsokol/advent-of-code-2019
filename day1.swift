#! /usr/bin/swift

var modules = [Int]()
while let line = readLine() {
  modules.append(Int(line)!)
}

print(modules.reduce(0, { $0 + ($1 / 3) - 2 }))

func calculate_fuel(_ module: Int) -> Int {
  var fuel = (module / 3) - 2
  if fuel > 0 {
    fuel += calculate_fuel(fuel)
  } else {
    fuel = 0
  }
  return fuel
}

print(modules.reduce(0, { $0 + calculate_fuel($1) }))
