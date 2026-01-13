// utils/grid.ts
export function cellToPercent(col: number, row: number, cols: number, rows: number) {
  return {
    x: ((col + 0.5) / cols) * 100,
    y: ((row + 0.5) / rows) * 100,
  }
}
