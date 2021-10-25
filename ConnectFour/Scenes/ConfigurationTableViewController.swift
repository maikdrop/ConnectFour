/*
 MIT License

Copyright (c) 2021 Maik Müller (maikdrop) <maikdrop@icloud.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  Abstract:
  The table view controller displays a list of game configuration possibilities, e.g. player names and colors.
 */

import UIKit

class ConfigurationTableViewController: UITableViewController {
    
    //MARK: - Properties
    private let dataSource = [AppStrings.ConfigurationTVC.players, AppStrings.ConfigurationTVC.colors]
    private let segues = [AppStrings.SegueIdentifier.editPlayer, AppStrings.SegueIdentifier.chooseColor]
    
}

// MARK: - Default view controller methods
extension ConfigurationTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
}
    
// MARK: - Table view data source and delegate methods
extension ConfigurationTableViewController {

    // data source
    override func numberOfSections(in tableView: UITableView) -> Int {

        dataSource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }

    // delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppStrings.CellIdentifier.config, for: indexPath)

        var content = cell.defaultContentConfiguration()
        
        content.text = dataSource[indexPath.section]
        
        cell.contentConfiguration = content

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: segues[indexPath.section], sender: nil)
    }
}
