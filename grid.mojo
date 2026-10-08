from std.random import random_si64


struct Grid[num_cols: Int, num_rows: Int]:
    var cells: List[Int]
    var next_cells: List[Int]
    var count: Int

    def __init__(out self):
        self.count = Self.num_cols * Self.num_rows
        self.cells = List[Int](length=self.count, fill=0)
        self.next_cells = List[Int](length=self.count, fill=0)

    comptime to_index = lambda (x: Int, y: Int) -> Int: (y * Self.num_cols + x)

    comptime to_coord = lambda (i: Int) -> Tuple[Int, Int]: (
        i % Self.num_cols,
        i // Self.num_cols,
    )

    def print_grid(self):
        var grid_str = ""
        for index in range(len(self.cells)):
            grid_str += "X" if self.cells[index] else "."
            if (
                index % Self.num_cols == Self.num_cols - 1
                and index != len(self.cells) - 1
            ):
                grid_str += "\n"
        print(grid_str)

    def is_valid_coord(self, coord: Tuple[Int, Int]) -> Bool:
        return not (
            coord[0] < 0
            or coord[0] >= Self.num_cols
            or coord[1] < 0
            or coord[1] >= Self.num_rows
        )

    def __setitem__(mut self, coord: Tuple[Int, Int], value: Int):
        if not self.is_valid_coord(coord):
            return
        self.cells[Self.to_index(coord[0], coord[1])] = value

    def __getitem__(self, coord: Tuple[Int, Int]) -> Int:  # raises -> Int:
        # if not self.is_valid_coord(coord):
        #     raise String(t"Invalid coordinate: ({coord[0]}, {coord[1]})")
        return self.cells[Self.to_index(coord[0], coord[1])]

    @staticmethod
    def random_grid(clumps: Int = 2) -> Self:
        var grid = Self()
        for _ in range(clumps):
            var idx = Int(random_si64(0, Int64(grid.count) - 1))
            var x, y = Self.to_coord(idx)
            grid[(x, y)] = 1

            for dx in range(-1, 2):
                for dy in range(-1, 2):
                    if not grid.is_valid_coord((x + dx, y + dy)):
                        continue
                    if random_si64(0, 3) > 0:
                        continue
                    grid[(x + dx, y + dy)] = 1

        return grid^

    def evolve_cell(mut self, i: Int):
        var is_alive = Bool(self.cells[i])
        self.next_cells[i] = 0

        var ncount = -1 if is_alive else 0
        var x, y = Self.to_coord(i)
        for dx in range(-1, 2):
            for dy in range(-1, 2):
                var nx = x + dx
                var ny = y + dy
                ncount += self.cells[Self.to_index(nx, ny)]

        if is_alive and (ncount == 2 or ncount == 3):
            self.next_cells[i] = 1
        elif not is_alive and ncount == 3:
            self.next_cells[i] = 1

    def evolve(mut self):
        for i in range(self.count):
            var x, y = Self.to_coord(i)
            if (
                x == 0
                or y == 0
                or x == Self.num_cols - 1
                or y == Self.num_rows - 1
            ):
                self.next_cells[i] = 0
                continue
            self.evolve_cell(i)

        var tmp = self.cells^
        self.cells = self.next_cells^
        self.next_cells = tmp^
