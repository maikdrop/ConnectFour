/*
 MIT License
 
 Copyright (c) 2021 Maik Müller (maikdrop) <maikdrop@icloud.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
  Abstract:
  The struct is the model for the game configuration.
  It can be created either from an array of json data or custom data.
 */

import Foundation

struct GameConfig: Codable {
    
    typealias Default = AppStrings.DefaultGameConfig
    
    static let url: URL? = {
        let urlString = "http://mac.local:8080/api/gameConfig"
        return URL(string: urlString)
    }()
    
    let id: Int
    var namePlayer1: String
    var namePlayer2: String
    var colorPlayer1: String
    var colorPlayer2: String
    
    init?(json: Data) {
        
        if let newValue = try? JSONDecoder().decode(GameConfig.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    init(id: Int = 0, namePlayer1: String = Default.name1, namePlayer2: String = Default.name2, colorPlayer1: String = Default.color1, colorPlayer2: String = Default.color2) {
        self.id = id
        self.namePlayer1 = namePlayer1
        self.namePlayer2 = namePlayer2
        self.colorPlayer1 = colorPlayer1
        self.colorPlayer2 = colorPlayer2
    }
}
