//
//  Post+CoreDataProperties.swift
//  Monalog-Test
//
//  Created by Benjamin Lim on 11/12/2016.
//  Copyright © 2016 Benjamin Lim. All rights reserved.
//

import Foundation
import CoreData 

extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post");
    }

    @NSManaged public var item: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var cost: Double
    @NSManaged public var user: User?

}
