/*
 MIT License

Copyright (c) 2021 Maik Müller (maikdrop) <maikdrop@icloud.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  
  Abstract:
  Simple helper class in order to encapsule the network communication and fetch data from a Url.
 */

import Foundation
import Network

class Network {
    
    // MARK: - Properties
    static let shared = Network()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    private(set) var isConnected: Bool = false
    
    private init() {
        
        monitor = NWPathMonitor()
    }
    
    /**
     Starts the monitoring of the network connection status.
     */
    func startMonitoring() {
        
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { [weak self] path in
            
            self?.isConnected = path.status == .satisfied
        }
    }
    
    /**
     Stops the monitoring of the network connection status.
     */
    func stopMonitoring() {
        
        monitor.cancel()
    }
    
   
    /**
     Fetches data from a url.
     
     - Parameter url: The url of the request.
     - Parameter completion: Calls back when the request is completed.
     */
    static func fetchData(from url: URL, completion: @escaping (Data?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                debugPrint("Error while loading from \(url)", String(describing: error))
                completion(nil)
                return
            }
            
            guard let responseData = data else {
                debugPrint("No data available from \(url)")
                completion(nil)
                return
            }
           
            // Verification of the http response code
            if let httpResponse = response as? HTTPURLResponse, HTTPStatusCode(code: httpResponse.statusCode) == .Success {
                
                completion(responseData)
                
            } else { completion(nil) }
        }
        task.resume()
    }
}
