//
//  JSONServiceObject.swift
//  Monalog-Test
//
//  Created by Benjamin Lim on 27/12/2016.
//  Copyright © 2016 Benjamin Lim. All rights reserved.
//

import Foundation

class JSONServiceObject {
    
    let data: Data? = nil
    
    func decode(data: Data) {
        if let objects = try? JSONSerialization.jsonObject(with: data, options: []) {
            let items = objects[0]["items"] as? [String: Any]
        }
    }
    
}
