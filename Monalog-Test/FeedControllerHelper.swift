//
//  FeedControllerHelper.swift
//  Monalog-Test
//
//  Created by Benjamin Lim on 10/12/2016.
//  Copyright © 2016 Benjamin Lim. All rights reserved.
//

import UIKit
import CoreData



extension FeedController {
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            do {
                let entityNames = ["User", "Post"]
                
                for entityName in entityNames {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                
                for object in objects! {
                    context.delete(object)
                }
            }
                try (context.save())
                
            } catch let err{
                print (err)
            }
        }
        
    }
    
    func setupData() {
        
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let ben = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
            ben.name = "ben"
            
            let postPetrol = NSEntityDescription.insertNewObject(forEntityName: "Post", into: context) as! Post
            postPetrol.item = "Petrol"
            postPetrol.cost = 55.76
            postPetrol.date = NSDate()
            postPetrol.user = ben
            
            let postShirt = NSEntityDescription.insertNewObject(forEntityName: "Post", into: context) as! Post
            postShirt.item = "Ralph Lauren Shirt"
            postShirt.cost = 120
            postPetrol.date = NSDate()
            postPetrol.user = ben
            
            do {
               try (context.save())
            } catch let err{
                print (err)
            }
            
            //posts = [postPetrol, postShirt]
 
        }
        
        loadData()
        
    }
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
            do {
                posts = try (context.fetch(fetchRequest)) as? [Post]

            } catch let err{
                print (err)
            }
        }
    }
    
    
}
