/*
 MIT License

Copyright (c) 2021 Maik Müller (maikdrop) <maikdrop@icloud.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
  Abstract:
  The extension adds the possibility to a UIViewController to show different alerts depending on the context.
 */

import UIKit

extension UIViewController {
    
    /**
     Presents an info alert with actions.
     
     - Parameter title: The title of the alert.
     - Parameter message: The message of the alert.
     - Parameter firstActionTitle: The title of the first action.
     - Parameter secondActionTitle: The title of the second action.
     - Parameter firstAction: The first action of the alert.
     - Parameter secondAction: The second action of the alert.
     
     Style for first action is .cancel. Style for second action is .default
     */
    func showAlertWithActions(title: String?,
                              message: String?,
                              firstActionTitle: String,
                              secondActionTitle: String,
                              firstAction: @escaping () -> Void = {},
                              secondAction: @escaping () -> Void = {}) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let firstAlertAction = UIAlertAction(title: firstActionTitle, style: .cancel) { _ in firstAction() }
        
        let secondAlertAction = UIAlertAction(title: secondActionTitle, style: .default) { _ in secondAction() }
        
        alertController.addAction(firstAlertAction)
        alertController.addAction(secondAlertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    /**
     Presents an info alert with an Ok button.
     
     - Parameter title: The title of the alert.
     - Parameter message: The message of the alert.
     - Parameter action: The action when the Ok button was tapped.
     */
    func showInfoAlert(title: String?, message: String?, action: @escaping () -> Void = {} ) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: AppStrings.Alert.okTitle, style: .default) { _ in action() }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    /**
     Presents an info alert with a link to the app settings.
     
     - Parameter title: The title of the alert.
     - Parameter message: The message of the alert.
     */
    func showInfoAlertWithLinkToSettings(title: String?, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: AppStrings.Alert.settingsBtn, style: .default) { _ in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
    
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        let okAction = UIAlertAction(title: AppStrings.Alert.okTitle, style: .default)
        alertController.addAction(okAction)
        alertController.addAction(settingsAction)
        present(alertController, animated: true, completion: nil)
    }
}
