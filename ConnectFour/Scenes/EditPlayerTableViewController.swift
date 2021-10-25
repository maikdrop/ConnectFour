/*
 MIT License

Copyright (c) 2021 Maik Müller (maikdrop) <maikdrop@icloud.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 Abstract:
 The table view controller allows the change of the player names.
 */

import UIKit

class EditPlayerTableViewController: UITableViewController {
    
    // MARK: - Typealias
    typealias Key = AppStrings.UserDefaults
    typealias Alert = AppStrings.Alert
    
    // MARK: - IBOutlets and Actions
    @IBOutlet private weak var saveActionBtn: UIBarButtonItem!
    
    @IBAction private func saveAction(_ sender: UIBarButtonItem?) {
        
        if players.count == 2 {
            
            if players[0] == players[1] {
                
                showInfoAlert(
                    title: Alert.sameNameTitle,
                    message: Alert.sameNameMsg)
                
            } else {
                
                tableView.endEditing(true)
                
                saveGameConfig()
                
                showInfoAlert(title: Alert.savedSuccessfullyTitle, message: "") { [weak self] in
                    
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    // MARK: - Properties
    private let userDefaults = UserDefaults.standard
    private var players = Array<String>()
    private var gameConfig: GameConfig?
}

// MARK: - Default view controller methods
extension EditPlayerTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = AppStrings.Titles.editPlayer
        setupDataSource()
    }
}

// MARK: - Table view data source and delegate methods
extension EditPlayerTableViewController {

    // data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        players.count
    }

    // delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: AppStrings.CellIdentifier.player, for: indexPath) as? EditPlayerTableViewCell {
            
            cell.playerTextField.text = players[indexPath.row]
            cell.playerTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            cell.playerTextField.tag = indexPath.row
            cell.playerTextField.delegate = self
            
            if indexPath.row == 0 { cell.playerTextField.becomeFirstResponder() }
            
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - Implementing UITextFieldDelegate protocol
extension EditPlayerTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if players.contains("") {
            
            let tag = textField.tag == 0 ? 1 : 0
            
            if let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as? EditPlayerTableViewCell {
                
                cell.playerTextField.becomeFirstResponder()
            }
            
        } else { saveAction(nil) }
        
        return true
    }
}

// MARK: - Utility methods
extension EditPlayerTableViewController {
    
    /**
     Setups the table view data source from User Defaults.
     */
    private func setupDataSource() {
        
        if let config = try? userDefaults.getObject(forKey: Key.currentGameConfigKey, as: GameConfig.self) {
            
            players.append(config.namePlayer1)
            players.append(config.namePlayer2)
            
            gameConfig = config
        }
    }
    
    /**
     Saves the new game configuration.
     */
    private func saveGameConfig() {
        
        if players.count == 2, var config = gameConfig {
            
            config.namePlayer1 = players[0]
            config.namePlayer2 = players[1]
            
            try? userDefaults.setObject(config, forKey: Key.currentGameConfigKey)
        }
    }
    
    /**
     Target method when the text field's text changes.
     
     - Parameter sender: The text field whos text changed.
     */
    @objc private func textFieldDidChange(_ sender: UITextField) {
        
        guard let text = sender.text else {
            return
        }
        
        players[sender.tag] = text
        
        saveActionBtn.isEnabled = !players.contains("")
        
        if let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? EditPlayerTableViewCell {
            
            cell.redLabel.isHidden = !text.isEmpty
        }
    }
}
