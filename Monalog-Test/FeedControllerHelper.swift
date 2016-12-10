//
//  FeedControllerHelper.swift
//  Monalog-Test
//
//  Created by Benjamin Lim on 10/12/2016.
//  Copyright © 2016 Benjamin Lim. All rights reserved.
//

import UIKit

class Post: NSObject {
    var user: String?
    var item: String?
    var cost: Double?
    var date: NSDate?
}

class User: NSObject {
    var name: String?
}


extension FeedController {
    
    func setupData() {
        let postPetrol = Post()
        postPetrol.item = "Petrol"
        postPetrol.cost = 55.76
        
        let postShirt = Post()
        postShirt.item = "Ralph Lauren Shirt"
        postShirt.cost = 120
        
        posts = [postPetrol, postShirt]
        
    }
    
    
}
