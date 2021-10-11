/*
 MIT License

Copyright (c) 2021 Maik Müller (maikdrop) <maikdrop@icloud.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit

extension UIViewController {
    
    /**
     Presents an error alert.
     
     - Parameter title: The title of the alert.
     - Parameter message: The message of the alert.
     - Parameter retryActionHandler: The handler for the retry action.
     
     Style for first action is .cancel. Style for second action is .default
     */
    func showAlertWithActions(title: String?,
                              message: String?,
                              firstActionTitle: String,
                              secondActionTitle: String,
                              firstAction: (() -> Void)?,
                              secondAction: (() -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let firstAlertAction = UIAlertAction(title: firstActionTitle, style: .cancel, handler: { _ in ( firstAction ?? {})() })
        
        let secondAlertAction = UIAlertAction(title: secondActionTitle, style: .default, handler: { _ in ( secondAction ?? {})() })
        
        alertController.addAction(firstAlertAction)
        alertController.addAction(secondAlertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    /**
     Presents an info alert.
     
     - Parameter title: The title of the alert.
     - Parameter message: The message of the alert.
     */
    func showInfoAlert(title: String?, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: AppStrings.Alert.okTitle, style: .default)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
