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
    
    let id: Int
    let color1: String
    let color2: String
    let name1: String
    let name2: String
    
    init?(json: Data) {
      
        if let newValue = try? JSONDecoder().decode([GameConfig].self, from: json), let gameConfig = newValue.first {
            self = gameConfig
        } else {
            return nil
        }
    }
    
    init(id: Int = 0, color1: String = Default.color1, color2: String = Default.color2, name1: String = Default.name1, name2: String = Default.name2) {
        self.id = id
        self.color1 = color1
        self.color2 = color2
        self.name1 = name1
        self.name2 = name2
    }
}
