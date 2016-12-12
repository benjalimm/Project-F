//
//  Message+CoreDataProperties.swift
//  Monalog-Test
//
//  Created by Benjamin Lim on 12/12/2016.
//  Copyright © 2016 Benjamin Lim. All rights reserved.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var isSender: Bool
    @NSManaged public var text: String?

}
