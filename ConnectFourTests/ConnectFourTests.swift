/*
 MIT License

Copyright (c) 2021 Maik Müller (maikdrop) <maikdrop@icloud.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import XCTest
@testable import ConnectFour

class ConnectFourTests: XCTestCase {

    var sut: ConnectFour!
    
    let rows = 6
    let columns = 7
    let player1 = 1
    let player2 = 2
    
    override func setUp() {
        sut = ConnectFour(rows: rows, columns: columns)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    /**
     Tests if the initial game field was created with 6 rows and 7 columns.
     */
    func testInitialGameField() {
        
        // Checks how many rows are in the game field
        XCTAssertEqual(sut.gameField.count, rows)
        
        for row in sut.gameField {
            
            // Checks if all rows contain 7 columns
            XCTAssertEqual(row.count, columns)
        }
        
        // Checks if all fields contain the number 0
        for row in sut.gameField {
            
            for field in row {
                
                XCTAssertEqual(field, 0)
            }
        }
    }
    
    /**
     Tests the setting of a disc by player 1 and 2.
     */
    func testSettingDiscsByPlayer() {
        
        let players = [player1, player2]
        
        for index in 0..<players.count {
            
            sut.setDisc(at: index, from: players[index])
          
            // first column in last row is checked for the disc
            if let lastRow = sut.gameField.last {
                
                XCTAssertEqual(lastRow[index], players[index])
            
            } else {
                
                XCTAssertTrue(false)
            }
        }
    }
    
    /**
     Tests the detection of 4 discs vertically.
     */
    func testDetectingFourDiscsVertically() {
        
        let discPos = [0, 0, 0, 0]
        
        for index in 0..<discPos.count {
            
            sut.setDisc(at: discPos[index], from: player2)
        }
    
        XCTAssertTrue(sut.hasFourDiscsConnected)
    }
    
    /**
     Tests the detection of 4 discs horizontally.
     
     It's tested if the detcting of discs works in both directions.
     */
    func testDetectingFourDiscsHorizontally() {
        
        // The following array contains arrays of Ints, which reflects the order in which column the disc will be set.
        // It starts from left to right -> the last entry of each array is important.
        // It's expected that the last disc connects 4 discs.
        let discPosColumns = [[0, 1, 2, 4, 3], [3, 2, 1, 0], [0, 2, 3, 1], [0, 1, 3, 2] , [0, 1, 2, 3]]
        
        for index in 0..<discPosColumns.count {
            
            for column in 0..<discPosColumns[index].count {
                
                sut.setDisc(at: discPosColumns[index][column], from: player2)
            }
            
            XCTAssertTrue(sut.hasFourDiscsConnected)
            
            sut = ConnectFour(rows: rows, columns: columns)
            
            XCTAssertFalse(sut.hasFourDiscsConnected)
            
        }
    }
    
    /**
     Tests the detection of 4 discs diagonally from top left to down right.
     
     It's tested if the detcting of discs works in both directions.
     */
    func testDetectingFourDiscsDiagonallyTopLeftDownRight() {
        
        // The following array contains arrays of Ints, which reflects the order in which column the disc will be set.
        // It starts from left to right -> the last entry of each array is important.
        // It's expected that the last disc connects 4 discs.
        let discPosColumn = [[3, 2, 1, 0], [0, 2, 3, 1], [0, 1, 3, 2] , [0, 1, 2, 3]]
        
        // count of vertical discs in column 0 - 3
        let countOfDiscsInColumn = [3, 2, 1, 0]
    
        for index in 0..<discPosColumn.count {
            
            for columnIndex in 0..<discPosColumn[index].count {
                
                for rowIndex in 0...countOfDiscsInColumn[columnIndex] {
                    
                    // this avoids 4 connected discs vertically at the first column of the game field
                    if columnIndex == 0 && rowIndex == 0 {
                        
                        sut.setDisc(at: columnIndex, from: player2)
                    
                    } else {
                        
                        sut.setDisc(at: columnIndex, from: player1)
                    }
                }
            }
            
            XCTAssertTrue(sut.hasFourDiscsConnected)
            
            sut = ConnectFour(rows: rows, columns: columns)
            
            XCTAssertFalse(sut.hasFourDiscsConnected)
        }
    }
    
    /**
     Tests the detection of 4 discs diagonally from top right to down left.
     
     It's tested if the detcting of discs works in both directions.
     */
    func testDetectingFourDiscsDiagonallyTopRightDownLeft() {
        
        // The following array contains arrays of Ints, which reflects the order in which column the disc will be set.
        // It starts from left to right -> the last entry of each array is important.
        // It's expected that the last disc connects 4 discs.
        let discPosColumn = [[6, 5, 4, 3], [6, 5, 3, 4], [6, 4, 3, 5], [3, 4, 5, 6]]
        
        // count of vertical discs in column 3 - 6
        let countOfDiscsInColumn = [3, 2, 1, 0]
    
        let lastColumnIndex = columns - 1
        
        for index in 0..<discPosColumn.count {
            
            for columnIndex in 0..<discPosColumn[index].count {
                
                for rowIndex in 0...countOfDiscsInColumn[columnIndex] {
                    
                    let columnOfDiscToSet = lastColumnIndex - columnIndex
                    
                    // this avoids 4 connected discs vertically at the last column of the game field
                    if columnOfDiscToSet == lastColumnIndex && rowIndex == 0 {
                        
                        sut.setDisc(at: columnOfDiscToSet, from: player2)
                    
                    } else {
                        
                        sut.setDisc(at: columnOfDiscToSet, from: player1)
                    }
                }
            }
           
            XCTAssertTrue(sut.hasFourDiscsConnected)
            
            sut = ConnectFour(rows: rows, columns: columns)
            
            XCTAssertFalse(sut.hasFourDiscsConnected)
        }
    }
    
    /**
     Tests the detection of available fields.
     */
    func testDetectingNoFieldsAvailable() {
        
        for rowIndex in 0..<rows - 1 {
            
            for columnIndex in 0..<columns - 1 {
                
                sut.setDisc(at: columnIndex, from: player2)
                
                if rowIndex == rows - 1 && columnIndex == columns - 1  {
                    
                    XCTAssertFalse(sut.fieldsAvailable)
                    
                } else {
                    
                    XCTAssertTrue(sut.fieldsAvailable)
                    
                }
            }
        }
    }
}
