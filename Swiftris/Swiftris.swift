//
//  Swiftris.swift
//  Swiftris
//
//  Created by Paulo Silva on 23/09/14.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

let NumColumns = 10
let NumRows = 20

let StartingColumn = 4
let StartingRow = 0

let PreviewColumn = 12
let PreviewRow = 1

class Swiftris {
  var blockArray:Array2D<Block>
  var nextShape:Shape?
  var fallingShape:Shape?
  
  init() {
    fallingShape = nil
    nextShape = nil
    blockArray = Array2D<Block>(columns: NumColumns, rows: NumRows)
  }
  
  func beginGame() {
    if (nextShape == nil) {
      nextShape = Shape.random(PreviewColumn, startingRow: PreviewRow)
    }
  }
  
  func newShape() -> (fallingShape:Shape?, nextShape:Shape?) {
    fallingShape = nextShape
    nextShape = Shape.random(PreviewColumn, startingRow: PreviewRow)
    fallingShape?.moveTo(StartingColumn, row: StartingRow)
    return (fallingShape, nextShape)
  }
}
