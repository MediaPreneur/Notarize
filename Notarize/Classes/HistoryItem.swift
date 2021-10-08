/*******************************************************************************
 * The MIT License (MIT)
 * 
 * Copyright (c) 2018 Jean-David Gadina - www.xs-labs.com
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

import Cocoa

@objc class HistoryItem: NSObject
{
    @objc public dynamic var date:    Date
    @objc public dynamic var uuid:    String
    @objc public dynamic var success: Bool
    @objc public dynamic var status:  Int
    @objc public dynamic var message: String
    @objc public dynamic var logURL:  String?
    
    class func ItemsFromDictionary( dict: [ AnyHashable : Any ]? ) -> [ HistoryItem ]
    {
        guard let history = dict?[ "notarization-history" ] as? [ AnyHashable : Any ],
              let items   = history[ "items" ]              as? [ Any ]
        else
        {
            return []
        }
        
        return items.compactMap
        {
            $0 as? [ AnyHashable : Any ]
        }
        .compactMap
        {
            HistoryItem( dict: $0 )
        }
    }
    
    init?( dict: [ AnyHashable : Any ] )
    {
        guard let date    = dict[ "Date" ]           as? Date,
              let uuid    = dict[ "RequestUUID" ]    as? String,
              let status  = dict[ "Status" ]         as? String,
              let code    = dict[ "Status Code" ]    as? NSNumber,
              let message = dict[ "Status Message" ] as? String
            else
        {
            return nil
        }
        
        self.date    = date
        self.uuid    = uuid
        self.success = status == "success"
        self.status  = code.intValue
        self.message = message
    }
    
    override func isEqual( _ object: Any? ) -> Bool
    {
        guard let o = object as? HistoryItem else
        {
            return false
        }
        
        return self.uuid == o.uuid
    }
    
    override var hash: Int
    {
        return self.uuid.hash
    }
}
