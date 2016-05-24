//
//  Message.swift
//  FourthBranchMessenger
//
//  Created by Matthew Tso on 5/3/16.
//  Copyright © 2016 Studio Tso. All rights reserved.
//

import Foundation
import CoreData

class MessageMO: NSManagedObject {
//    var text: String?
//    var incoming = false
//    var timestamp: NSDate?
    @NSManaged var text: String
    @NSManaged var incoming: NSNumber
    @NSManaged var timestamp: NSDate
    
//    init(text: String, incoming: NSNumber, timestamp: NSDate) {
//        self.text = text
//        self.incoming = incoming
//        self.timestamp = timestamp
//    }
}