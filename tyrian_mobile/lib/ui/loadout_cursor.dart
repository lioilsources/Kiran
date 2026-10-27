/// Pad/keyboard cursor for the ComCenter: a 2D grid over the LOADOUT rows
/// (FRONT / LEFT / RIGHT / GEN) plus the bottom action bar.
///
/// Pure state, no widgets: the screen tells it how many cells each row has
/// right now (chips that are not locked + UPG/BUY + SELL when there is
/// something to sell), and the cursor only moves and clamps. Rows with
/// different cell counts keep the column as far as it fits.
enum LoadoutRegion { loadout, bottomBar }

class LoadoutCursor {
  static const rowCount = 4;

  LoadoutRegion region = LoadoutRegion.loadout;
  int row = 0;
  int cell = 0;
  int bottomIndex = 0;

  /// Clamp [cell] after the row's contents changed (a sell removed SELL, a
  /// tier unlock added a chip).
  void clamp(int cellsInRow) {
    if (cellsInRow <= 0) {
      cell = 0;
    } else if (cell >= cellsInRow) {
      cell = cellsInRow - 1;
    }
  }

  /// ↑/↓ and LB/RB. [cellCounts] has [rowCount] entries; [bottomCount] is the
  /// number of bottom-bar buttons. Moving down off GEN enters the bottom bar;
  /// moving up from it returns to GEN. Up from FRONT stays put.
  void moveRow(int delta, List<int> cellCounts, int bottomCount) {
    if (region == LoadoutRegion.bottomBar) {
      if (delta < 0) {
        region = LoadoutRegion.loadout;
        row = rowCount - 1;
        clamp(cellCounts[row]);
      }
      return;
    }
    final next = row + delta;
    if (next < 0) return;
    if (next >= rowCount) {
      if (bottomCount > 0) {
        region = LoadoutRegion.bottomBar;
        bottomIndex = bottomIndex.clamp(0, bottomCount - 1);
      }
      return;
    }
    row = next;
    clamp(cellCounts[row]);
  }

  /// Tab / Shift+Tab: like [moveRow] but wraps from the bottom bar to FRONT
  /// and from FRONT back to the bottom bar, so it cycles the whole screen.
  void cycle(int delta, List<int> cellCounts, int bottomCount) {
    if (region == LoadoutRegion.bottomBar) {
      if (delta > 0) {
        region = LoadoutRegion.loadout;
        row = 0;
        clamp(cellCounts[row]);
      } else {
        moveRow(-1, cellCounts, bottomCount);
      }
      return;
    }
    if (delta < 0 && row == 0) {
      if (bottomCount > 0) {
        region = LoadoutRegion.bottomBar;
        bottomIndex = bottomIndex.clamp(0, bottomCount - 1);
      }
      return;
    }
    moveRow(delta, cellCounts, bottomCount);
  }

  /// ←/→ within the current row or bottom bar. Returns false when the move
  /// would leave the row on that side — the host may hand focus elsewhere
  /// (the skin grid on the 3.x line); here it just stays.
  bool moveCell(int delta, List<int> cellCounts, int bottomCount) {
    if (region == LoadoutRegion.bottomBar) {
      final next = bottomIndex + delta;
      if (next < 0 || next >= bottomCount) return false;
      bottomIndex = next;
      return true;
    }
    final next = cell + delta;
    if (next < 0 || next >= cellCounts[row]) return false;
    cell = next;
    return true;
  }
}
