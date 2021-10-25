/*
 MIT License

Copyright (c) 2021 Maik Müller (maikdrop) <maikdrop@icloud.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  Abstract:
  The view controller contains the UI logic of the game and receives
  the player intents, e.g. setting a disc or starting a new game. The view controller
  talks to the game model and synchronizes the game view accordingly to the changes.
  If the game is over two different alerts can be showing up, e.g. one player has won or
  no more fields are available. In order to start the game, a custom game configuration is
  fetched from the internet and stored locally. If an error occurs during fetching, an alert
  is showing up and the user can retry the fetch or use the standard configuration instead.
 */

import UIKit

class ConnectFourViewController: UIViewController {
    
    // MARK: - Typealias
    typealias DefConfig = AppStrings.DefaultGameConfig
    typealias Key = AppStrings.UserDefaults
    
    // MARK: - IBOutlets and Actions
    @IBOutlet private weak var playField: UIStackView!
    
    @IBOutlet private weak var player1Lbl: UILabel!
    
    @IBOutlet private weak var player2Lbl: UILabel!
    
    @IBOutlet weak var playerAdviceLbl: UILabel!
    
    @IBOutlet private var setDiscButtons: [UIButton]!
    
    @IBOutlet weak var editPlayer: UIBarButtonItem!
    
    /**
     Starts a new game.
     
     - Parameter sender: The sender of the action.
     */
    @IBAction private func startNewGame(_ sender: UIBarButtonItem) {
        gameState = .new
    }
    
    /**
     Sets a disc in the game field.
     
     - Parameter sender: The sender of the action.
     */
    @IBAction private func setDisc(_ sender: UIButton) {
    
        if let column = setDiscButtons.firstIndex(of: sender) {
            game.setDisc(at: column, from: currentPlayer)
            currentPlayer = currentPlayer == 1 ? 2 : 1
            updateViewFromModel()
        }
    }
    
    // MARK: - Properties
    private var game: ConnectFour! {
        didSet {
            if game.hasFourDiscsConnected || !game.fieldsAvailable {
                gameState = .end
            }
        }
    }
    
    private var gameConfig: GameConfig! {
        didSet {
            
            players = Players(player1: gameConfig.namePlayer1, player2: gameConfig.namePlayer2)
            
            if oldValue == nil {
                
                gameState = .new
            
            } else {
                
                updateViewFromModel()
            }
        }
    }
    
    private var players: Players! {
        didSet {
            // Player 1 starts
            currentPlayer = players.getNumber(from: players.player1)
        }
    }
    
    private var gameState: GameState? {
        didSet {
            switch gameState {
            case .new:
                playField.isUserInteractionEnabled = true
                createNewGame()
                updateViewFromModel()
            case .end:
                playField.isUserInteractionEnabled = false
                checkForGameEnd()
            default: break
            }
        }
    }
    
    private var currentPlayer = 0
    private let userDefaults = UserDefaults.standard
}

// MARK: - Default view controller methods
extension ConnectFourViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = AppStrings.Titles.game
        checkUserDefaultsForGameConfig()
    }
}

// MARK: - UI logic methods
extension ConnectFourViewController {
    
    /**
     Updates the UI from the model.
     */
    func updateViewFromModel() {
        
        configTopLabels()
        
        for rowIndex in playField.subviews.indices.reversed() {
            
            if rowIndex > 0 {
                
                if let fieldLabelStackView = playField.subviews[rowIndex] as? UIStackView {
                    
                    fieldLabelStackView.subviews.enumerated().forEach { (columnIndex, fieldLabel) in
                        
                        //rowIndex - 1 because the play field stackview contains the setDiscButtons but of course the model doesn't
                        let setFieldNumber = game.gameField[rowIndex - 1][columnIndex]
                        
                        if setFieldNumber == 0 {
                            fieldLabel.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
                        } else if setFieldNumber == 1 {
                            fieldLabel.backgroundColor = player1Lbl.textColor
                        } else if setFieldNumber == 2 {
                            fieldLabel.backgroundColor = player2Lbl.textColor
                        }
                    }
                }
            }
        }
    }
    
    /**
     Configures the player labels with color and frame in order to display which player is up.
     */
    private func configTopLabels() {
       
        playField.isHidden = false
        playerAdviceLbl.isHidden = false
        
        player1Lbl.text = " " + players.player1 + " "
        player1Lbl.textColor = UIColor(hex: gameConfig.colorPlayer1)
        player1Lbl.layer.borderWidth = 2
        player1Lbl.layer.borderColor = UIColor.clear.cgColor
        
        player2Lbl.text = " " + players.player2 + " "
        player2Lbl.textColor = UIColor(hex: gameConfig.colorPlayer2)
        player2Lbl.layer.borderWidth = 2
        player2Lbl.layer.borderColor = UIColor.clear.cgColor
        
        switch currentPlayer {
        case 1: player1Lbl.layer.borderColor = player1Lbl.textColor.cgColor
        case 2: player2Lbl.layer.borderColor = player2Lbl.textColor.cgColor
        default: break
        }
    }
    
    /**
     Checks for the end of the game.
     */
    private func checkForGameEnd() {
        
        var title = "", message = ""
        
        if game.hasFourDiscsConnected {
            
            title = AppStrings.Alert.victoryTitle
            message = players.getName(from: currentPlayer) + " " + AppStrings.Alert.victoryMsg
            
        } else if !game.fieldsAvailable {
            
            title = AppStrings.Alert.noMoreFieldsTitle
        }
        
        if !title.isEmpty {
            
            showAlertWithActions(title: title,
                                 message: message,
                                 firstActionTitle: AppStrings.Alert.okTitle,
                                 secondActionTitle: AppStrings.Alert.newGameTitle,
                                 secondAction: { self.gameState = .new } )
        }
    }
}

// MARK: - Game configuration
extension ConnectFourViewController {
    
    /**
     Creates a new game.
     */
    private func createNewGame() {
        
        let rows = playField.subviews.count - 1
        
        let columns = setDiscButtons.count
        
        game = ConnectFour(rows: rows, columns: columns)
    }
    
    /**
     Checks in the user defaults if the game configuration exists. If not, the configuration will be fetched over the internet.
     */
    private func checkUserDefaultsForGameConfig() {
        
        if let config = try? userDefaults.getObject(forKey: Key.currentGameConfigKey, as: GameConfig.self) {
            
            gameConfig = config
        
        } else { gameConfig = GameConfig() }
    }
    
    @objc private func onDoneAction() {
        
        presentedViewController?.dismiss(animated: true)
        
        checkUserDefaultsForGameConfig()
    }
}

// MARK: - Navigation
extension ConnectFourViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == AppStrings.SegueIdentifier.settings {
            
            if let settingsVC = (segue.destination as? UINavigationController)?.viewControllers.first {
                
                settingsVC.isModalInPresentation = true
                settingsVC.navigationItem.title = AppStrings.Titles.configuration
                settingsVC.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .done,
                    target: self,
                    action: #selector(onDoneAction)
                )
            }
        }
    }
}
