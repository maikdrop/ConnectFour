/*
 MIT License

Copyright (c) 2021 Maik Müller (maikdrop) <maikdrop@icloud.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 Abstract:
 The view controller makes it possible to choose a color configuration for the player.
 The configurations are fetched over the network and stored. If an error occurs during
 the fetch or if the airplane mode is enabled, the previous stored configurations will be displayed.
 */

import UIKit
import Combine

class ChooseColorTableViewController: UITableViewController {
    
    // MARK: - Typealias
    typealias Key = AppStrings.UserDefaults
    typealias Alert = AppStrings.Alert
    typealias Cell = AppStrings.CellIdentifier

    // MARK: - Properties
    private let loadingVC = LoadingViewController()
    private let userDefaults = UserDefaults.standard
    private var currentGameConfig: GameConfig?
    private var storedGameConfigs = [GameConfig]()
    private var cancellableObserver: Cancellable?
    
    private var fetchedGameConfigs = [GameConfig]() {
        didSet {
            if fetchedGameConfigs != storedGameConfigs {
                try? userDefaults.setObject(fetchedGameConfigs, forKey: Key.fetchedGameConfigsKey)
            }
            tableView.reloadData()
        }
    }
}

// MARK: - Default view controller methods
extension ChooseColorTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = AppStrings.Titles.chooseColors
        getCurrentUsedGameConfig()
        getStoredGameConfigs()
        fetchGameConfigs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSubscriberForNotificationCenter()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancellableObserver?.cancel()
    }
}

// MARK: - Table view data source and delegate methods
extension ChooseColorTableViewController {
    
    // data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        fetchedGameConfigs.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        AppStrings.HeaderTitles.colorConfig + " " + String(section + 1)
    }

    // delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.color, for: indexPath)
        
        let combination = NSMutableAttributedString()
        
        var content = cell.defaultContentConfiguration()
        
        if let fetchedcolorPlayer1 = UIColor(hex: fetchedGameConfigs[indexPath.section].colorPlayer1), let fetchedcolorPlayer2 = UIColor(hex: fetchedGameConfigs[indexPath.section].colorPlayer2)  {
            
            var attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), .foregroundColor: fetchedcolorPlayer1]
            let colorStringPlayer1 = NSAttributedString(string: currentGameConfig?.namePlayer1 ?? "", attributes: attributes)
            
            attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), .foregroundColor: fetchedcolorPlayer2]
            let colorStringPlayer2 = NSAttributedString(string: currentGameConfig?.namePlayer2 ?? "", attributes: attributes)
            
            combination.append(colorStringPlayer1)
            combination.append(NSAttributedString(string: "        "))
            combination.append(colorStringPlayer2)
            
            if fetchedcolorPlayer1 == UIColor(hex: (currentGameConfig?.colorPlayer1) ?? "") &&
                fetchedcolorPlayer2 == UIColor(hex: (currentGameConfig?.colorPlayer2) ?? "") {
                
                cell.accessoryType = .checkmark
            }
        }
        
        content.attributedText = combination
        
        cell.contentConfiguration = content

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.visibleCells.forEach { cell in cell.accessoryType = .none }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        currentGameConfig?.colorPlayer1 = fetchedGameConfigs[indexPath.section].colorPlayer1
        currentGameConfig?.colorPlayer2 = fetchedGameConfigs[indexPath.section].colorPlayer2
        
        try? userDefaults.setObject(currentGameConfig, forKey: Key.currentGameConfigKey)
    }
}

// MARK: - Handling game configurations
extension ChooseColorTableViewController {
    
    /**
     Fetches the game configurations from an external source.
     */
    private func fetchGameConfigs() {
        
        if Network.shared.isConnected {
            
            if let url = GameConfig.url {
                
                add(loadingVC)
                
                Network.fetchData(from: url) { fetchedData in
                    
                    DispatchQueue.main.async {
                        
                        self.loadingVC.remove()
                        
                        if let fetcheGameConfigs = self.getGameConfigs(from: fetchedData) {
                            
                            self.fetchedGameConfigs = fetcheGameConfigs
                            
                        } else { self.errorWhileFetchingGameConfigs() }
                    }
                }
            }
        } else {
            
            DispatchQueue.main.async {
                
                self.noInternetConnectionAvailable()
            }
        }
    }
    
    /**
     Loads the current game configuration from the User Defaults.
     */
    private func getCurrentUsedGameConfig() {
        
        if let config = try? userDefaults.getObject(forKey: Key.currentGameConfigKey, as: GameConfig.self) {

            currentGameConfig = config
        }
    }

    /**
     Parses the game configuration from the data which was fetched from an external source.
     
     - Parameter fetchedData: The fetched data which will be parsed.
     
     - Returns: The parsed game configurations.
     */
    private func getGameConfigs(from fetchedData: Data?) -> [GameConfig]? {
        
        var gameConfig = [GameConfig]()
        
        if let data = fetchedData {
            
            if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] {
                
                jsonArray.forEach { config in
                    
                    if let data = try? JSONSerialization.data(withJSONObject: config, options: []), let fetchedGameConfig = GameConfig(json: data) {
                        
                        gameConfig.append(fetchedGameConfig)
                    }
                }
            }
        }
        return gameConfig.isEmpty ? nil : gameConfig
    }
    
    /**
     Loads the game configurations, which were fetched and stored last time, from the User Defaults.
     */
    private func getStoredGameConfigs() {
        
        if let configs = try? userDefaults.getObject(forKey: Key.fetchedGameConfigsKey, as: [GameConfig].self) {
            
            storedGameConfigs = configs
        }
    }
    
}

// MARK: - Showing alerts
extension ChooseColorTableViewController {
    
    /**
     Displays an error alert when an error occurs during the fetch of the game configurations.
     */
    private func errorWhileFetchingGameConfigs() {
        
        fetchedGameConfigs = storedGameConfigs
        
        showAlertWithActions(title: Alert.errorTitle,
                                  message: Alert.errorMsg,
                                  firstActionTitle: Alert.okTitle,
                                  secondActionTitle: Alert.retryActionTitle,
                                  secondAction: { self.fetchGameConfigs() }
        )
    }
    
    /**
     Displays an info alert when the airplane is enabled.
     */
    private func noInternetConnectionAvailable() {
        
        fetchedGameConfigs = storedGameConfigs
        
        showInfoAlertWithLinkToSettings(title: Alert.noConnectionAlertTitle, message: "")
    }
    
}

// MARK: - Utility methods
extension ChooseColorTableViewController {
    
    /**
     Setups an observer in order to fetch game configurations from an external source when the app moves to the foreground.
     */
    private func setupSubscriberForNotificationCenter() {
        
        cancellableObserver = NotificationCenter.default.publisher(
            for: UIApplication.willEnterForegroundNotification,
            object: nil)
            .sink { [weak self] _ in self?.fetchGameConfigs() }
    }
}
