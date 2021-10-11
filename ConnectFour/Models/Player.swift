/*
 MIT License

Copyright (c) 2021 Maik Müller (maikdrop) <maikdrop@icloud.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  Abstract:
  The struct is a small model class for players, who wants to play "Four Connect".
  It's mainly used to map name and player number.
 */

import Foundation

struct Players {
    
    let player1: String
    let player2: String
    
    init(player1: String, player2: String) {
        self.player1 = player1
        self.player2 = player2
    }
    
    func getNumber(from player: String) -> Int {
        
        switch player {
        case player1: return 1
        case player2: return 2
        default: return 0
        }
    }
    
    func getName(from playerNumber: Int) -> String {
        
        switch playerNumber {
        case 1: return player1
        case 2: return player2
        default: return ""
        }
    }
}
