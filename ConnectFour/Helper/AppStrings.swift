/*
 MIT License

Copyright (c) 2021 Maik Müller (maikdrop) <maikdrop@icloud.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  Abstract:
  The enum contains all used strings in the application.
 */
 
import Foundation

enum AppStrings {
    
    enum Alert {
        
        static let errorTitle = "Oops"
        static let errorMsg: String = "Something went wrong while customizing the game. Do you want to use the default configuration or retry it?"
        static let victoryTitle = "Congratulations 👏"
        static let victoryMsg = "won the game!"
        static let noMoreFieldsTitle = "No more fields available"
        static let defaultTitle = "Default"
        static let retryActionTitle = "Retry"
        static let okTitle = "Ok"
        static let newGameTitle = "New Game"
    }
    
    enum DefaultGameConfig {
        
        static let name1 = "Player1"
        static let name2 = "Player2"
        static let color1 = "#FF0000"
        static let color2 = "#0000FF"
    }
    
    enum Game {
        
        static let title = "Connect Four"
    }
    
    enum UserDefaults {
        
        static let gameConfigKey = "gameConfigKey"
    }
    
    enum SegueIdentifier {
        
        static let editPlayer = "editPlayerSegue"
    }
    
    enum CellIdentifier {
        
        static let player = "playerIdentifier"
        static let color = "colorIdentifier"
    }
    
    enum StoryboardIdentifier {
        
        static let colorsVC = "ColorsTableViewController"
        static let main = "Main"
    }
    
    enum HeaderTitles {
        
        static let editPlayer = "Edit Name"
        static let colors = "Colors"
        
    }
}
