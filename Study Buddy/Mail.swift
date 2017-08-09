//
//  Mail.swift
//  Study Buddy
//
//  Created by Gaby Ecanow on 8/8/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit

class Mail: NSObject {
    var fromID : String!
    var fromName : String!
    var text : String!
    
    convenience init(id: String, name: String, text: String) {
        self.init()
        
        self.fromID = id
        self.fromName = name
        self.text = text
    }
}
