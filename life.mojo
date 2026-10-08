from std.random import seed
from std.time import sleep

from grid import Grid


def main():
    comptime gridw: Int = 80
    comptime gridh: Int = 20
    comptime grid_count: Int = 400

    seed()
    var grid = Grid[gridw, gridh].random_grid(grid_count)

    while True:
        for gen in range(100):
            print(t"\033[H\033[J\nGeneration: {gen}{' ' * 4}")
            grid.evolve()
            grid.print_grid()
            sleep(0.1)
        grid = Grid[gridw, gridh].random_grid(grid_count)
