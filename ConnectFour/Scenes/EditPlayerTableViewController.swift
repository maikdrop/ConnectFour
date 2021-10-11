/*
 MIT License

Copyright (c) 2021 Maik Müller (maikdrop) <maikdrop@icloud.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 Abstract:
 The view controller allows the change of the player names.
 */

import UIKit

class EditPlayerTableViewController: UITableViewController {
    
    // MARK: - Typealias
    typealias Key = AppStrings.UserDefaults
    typealias Alert = AppStrings.Alert
    
    // MARK: - IBOutlets and Actions
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
    
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        
        if players.count == 2 {
            
            if players[0] == players[1] {
                
                showInfoAlert(
                    title: Alert.sameNameTitle,
                    message: Alert.sameNameMsg)
                
            } else {
                
                saveGameConfig()
                oneDoneBlock()
            }
        }
    }

    // MARK: - Properties
    private let userDefaults = UserDefaults.standard
    private var players = Array<String>()
    
    var oneDoneBlock = { }
}

// MARK: - Default view controller methods
extension EditPlayerTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
    }
}

// MARK: - Table view data source methods
extension EditPlayerTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        players.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        AppStrings.HeaderTitles.editPlayer
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: AppStrings.CellIdentifier.player, for: indexPath) as? EditPlayerTableViewCell {
            
            cell.playerTextField.text = players[indexPath.row]
            cell.playerTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            cell.playerTextField.tag = indexPath.row
            
            if indexPath.row == 0 { cell.playerTextField.becomeFirstResponder() }
            
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - Utility methods
extension EditPlayerTableViewController {
    
    /**
     Setups the table view data source from User Defaults.
     */
    private func setupDataSource() {
        
        if let config = try? userDefaults.getObject(forKey: Key.gameConfigKey, as: GameConfig.self) {
            
            players.append(config.name1)
            players.append(config.name2)
        }
    }
    
    /**
     Saves the new game configuration.
     */
    private func saveGameConfig() {
        
        let gameConfig = GameConfig(name1: players[0], name2: players[1])
        
        try? userDefaults.setObject(gameConfig, forKey: Key.gameConfigKey)
    }
    
    /**
     Target method when a text field changes.
     */
    @objc private func textFieldDidChange(_ sender: UITextField) {
        
        guard let text = sender.text else {
            return
        }
        
        doneBtn.isEnabled = !text.isEmpty
        
        players[sender.tag] = text
    }
}
