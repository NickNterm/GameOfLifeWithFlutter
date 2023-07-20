// Cell class
// cell is the small square in the grid
class Cell {
  // is alive saves its state
  bool isAlive;

  // neighbors saves the number of neighbors it has
  int neighbors;

  // Constractor
  Cell({
    required this.isAlive,
    this.neighbors = 0,
  });

  // is alive setter
  void setIsAlive(bool b) {
    isAlive = b;
  }

  // incrementNeighbors for the neighbors
  void incrementNeighbors() {
    neighbors++;
  }

  // logic for the next generation
  bool shouldLiveNextGen() {
    if (isAlive == true) {
      if (neighbors == 2 || neighbors == 3) {
        return true;
      } else {
        return false;
      }
    } else {
      if (neighbors == 3) {
        return true;
      } else {
        return false;
      }
    }
  }

  // simple copy function
  Cell copyWith({
    bool? isAlive,
    int? neighbors,
  }) {
    return Cell(
      isAlive: isAlive ?? this.isAlive,
      neighbors: neighbors ?? this.neighbors,
    );
  }
}
