//
//  Buddy.swift
//  Study Buddy
//
//  Created by Gaby Ecanow on 8/3/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class Buddy: NSObject {
    
    var id : String!
    var name : String!
    var lowercaseName : String!
    var email : String!
    
    convenience init(bud: String) {
        self.init()
        id = bud
        name = ""
        lowercaseName = ""
        email = ""
    }
    
    convenience init(bud: String, called: String, at: String) {
        self.init()
        self.id = bud
        self.name = called
        self.lowercaseName = called.lowercased()
        self.email = at
    }
}
