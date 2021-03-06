/*
 MIT License

Copyright (c) 2021 Maik Müller (maikdrop) <maikdrop@icloud.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
  Abstract:
  The extension adds the following possibilities to the User Defaults:
    - retrieve objects which conform to Decodable protocol in order to decode them with the JSONDecoder
    - store ojects which conform to encodable protocol in order to encode them with the JSONEncoder
 */

import Foundation

extension UserDefaults {
    
    /**
     Sets the object for the specified key.
     
     - Parameter object: The object to store in the defaults database.
     - Parameter defaultName: The key with which to associate the object.
     */
    func setObject<Object>(_ object: Object, forKey defaultName: String) throws where Object: Encodable {

        let data = try JSONEncoder().encode(object)
        self.set(data, forKey: defaultName)
    }

    /**
     Returns the object associated with the specified key.
     
     - Parameter forKey: A key in the current user‘s defaults database.
     - Parameter type: The type of the object.
     
     - Returns: A JSON decoded object.
     */
    func getObject<Object>(forKey: String, as type: Object.Type) throws -> Object? where Object: Decodable {

        guard let data = self.data(forKey: forKey) else {
            return nil
        }
        return try JSONDecoder().decode(type, from: data)
    }
}

