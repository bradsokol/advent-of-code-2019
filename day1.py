#! /usr/bin/env python3

from functools import reduce

modules = list(map(lambda module: int(module.strip()), tuple(open('day1.txt', 'r'))))

print(reduce(lambda memo, m: memo + (int(m / 3.0) - 2), modules, 0))

def calculate_fuel(module):
    fuel = int(module / 3.0) - 2
    if fuel > 0:
        fuel += calculate_fuel(fuel)
    else:
        fuel = 0
    return fuel

print(reduce(lambda memo, module: memo + calculate_fuel(module), modules, 0))
