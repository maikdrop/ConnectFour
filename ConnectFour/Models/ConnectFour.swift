/*
 MIT License

Copyright (c) 2021 Maik Müller (maikdrop) <maikdrop@icloud.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  Abstract:
  The class is the model of the game "Connect Four". It encapsults the game logic in order
  to set a disc in a column of the game field. Furthermore it detects if 4 discs are in a row
  horizontally, vertically or diagonally. If so, a notfication about the game end is send to
  all who are interested in. The same message is sent when all fields have been set in the game field.
*/

import Foundation

struct ConnectFour {
    
    // MARK: - Properties
    private(set) var gameField = [Array<Int>]()
    
    private let discsToWin = 4
    
    private(set) var hasFourDiscsConnected = false
    
    private(set) var fieldsAvailable = true
    
    // MARK: - Create a game
    init(rows: Int, columns: Int) {

        let columns = Array(repeating: 0, count: columns)
        
        for _ in 0..<rows {
        
            gameField.insert(columns, at: 0)
        }
    }
}

// MARK: - Game logic
extension ConnectFour {
    
    /**
     Sets a disk in a column.
     
     - Parameter column: The colummn of the game field where the disc will be set.
     - Parameter player: The player who sets the disc. Player number must be 1 or 2.
     */
    mutating func setDisc(at column: Int, from player: Int) {
      
        if player == 1 || player == 2 {
            
            for index in gameField.indices.reversed() {
               
                if gameField[index][column] == 0 {
                    
                    gameField[index][column] = player
                    
                    verifySetDisc(at: index, at: column, for: player)
                    
                    verifyAvailableDiscs()
                    
                    return
                }
            }
        }
    }
    
    /**
     Verifies if 4 discs are connected.
     
     - Parameter row: The row of the game field where the last disc was set.
     - Parameter column: The colummn of the game field where the last disc was set.
     - Parameter player: The player who set the disc.
     */
    private mutating func verifySetDisc(at row: Int, at column: Int, for player: Int) {
        
        if checkForDiskHorizontally(at: row, at: column, for: player) {
            print("WIN Horizontally")
            hasFourDiscsConnected = true
            
        } else if checkForDisksVertically(at: row, at: column, for: player) {
            print("WIN Vertically")
            hasFourDiscsConnected = true
        
        } else if checkForDisksDiagonallyTopLeftDownRight(at: row, at: column, for: player) {
            print("WIN DiagonallyTopLeftDownRight")
            hasFourDiscsConnected = true
        
        } else if checkForDisksDiagonallyTopRightDownLeft(at: row, at: column, for: player) {
            print("WIN DiagonallyDownTopRightDownLeft")
            hasFourDiscsConnected = true
        }
    }
    
    /**
     Verifies if still fields are available in the first row of the game field.
     */
    private mutating func verifyAvailableDiscs() {
        
        if let firstRow = gameField.first, !firstRow.contains(0) && !hasFourDiscsConnected {
            
            fieldsAvailable = false
        }
    }

    // MARK: - Following fucntions verify if 4 discs are connected horizontally, vertically or diagonally
    
    /**
     Checks if 4 discs are connected right horizontally.
     
     - Parameter row: The row of the game field where the last disc was set.
     - Parameter column: The colummn of the game field where the last disc was set.
     - Parameter player: The player who set the disc.
     
     - Returns: True if 4 discs are connected and false if not.
     */
    private func checkForDiskHorizontally(at row: Int, at column: Int, for player: Int) -> Bool {
        
        let row = gameField[row]
        
        var foundDiscs = 0
        
        // check left
        for index in 0..<discsToWin {
            
            if let field = row[optional:column - index], field == player {
                
                foundDiscs += 1
            
            } else { break }

        }
        
        // check right
        for index in 1..<discsToWin {
            
            if let field = row[optional:column + index], field == player {
                
                foundDiscs += 1
            
            } else { break }
        }
        
        return foundDiscs >= discsToWin
    }
    
    /**
     Checks if 4 discs are connected down vertically.
     
     - Parameter row: The row of the game field where the last disc was set.
     - Parameter column: The colummn of the game field where the last disc was set.
     - Parameter player: The player who set the disc.
     
     - Returns: True if 4 discs are connected and false if not.
     */
    private func checkForDisksVertically(at row: Int, at column: Int, for player: Int) -> Bool {
        
        var foundDiscs = 0
        
        // check down
        for index in 0..<discsToWin {
           
            // subscript checks if index exists and returns either nil or the value at the index
            if let row = gameField[optional:row + index], row[column] == player {
                
                foundDiscs += 1
                
            } else { break }
        }
        
        return foundDiscs >= discsToWin
    }
    
    /**
     Checks if 4 discs are connected diagonally from left to right.
     
     - Parameter row: The row of the game field where the last disc was set.
     - Parameter column: The colummn of the game field where the last disc was set.
     - Parameter player: The player who set the disc.
     
     - Returns: True if 4 discs are connected and false if not.
     */
    private func checkForDisksDiagonallyTopLeftDownRight(at row: Int, at column: Int, for player: Int) -> Bool {
        
        var foundDiscs = 0
        
        // check diagonaly top left
        for index in 0..<discsToWin {
            
            // subscript checks if index exists and returns either nil or the value at the index
            if let row = gameField[optional:row - index], let field = row[optional: column - index], field == player  {
                
                foundDiscs += 1
                
            } else { break }
        }
        
        // check diagonaly down right
        for index in 1..<discsToWin {
            
            // subscript checks if index exists and returns either nil or the value at the index
            if let row = gameField[optional:row + index], let field = row[optional: column + index], field == player  {
                
                foundDiscs += 1
                
            } else { break }
        }
        
        return foundDiscs >= discsToWin
    }
    
    /**
     Checks if 4 discs are connected diagonally from right to left.
     
     - Parameter row: The row of the game field where the last disc was set.
     - Parameter column: The colummn of the game field where the last disc was set.
     - Parameter player: The player who set the disc.
     
     - Returns: True if 4 discs are connected and false if not.
     */
    private func checkForDisksDiagonallyTopRightDownLeft(at row: Int, at column: Int, for player: Int) -> Bool {
        
        var foundDiscs = 0
        
        // check diagonaly top right
        for index in 0..<discsToWin {
            
            // subscript checks if index exists and returns either nil or the value at the index
            if let row = gameField[optional:row - index], let field = row[optional: column + index], field == player  {
                
                foundDiscs += 1
                
            } else { break }
        }
        
        // check diagonaly down left
        for index in 1..<discsToWin {
            
            // subscript checks if index exists and returns either nil or the value at the index
            if let row = gameField[optional:row + index], let field = row[optional: column - index], field == player  {
                
                foundDiscs += 1
                
            } else { break }
        }
        
        return foundDiscs >= discsToWin
    }
}
