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
                let entityNames = ["Post"]
                
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
            
            createPostWithText(item: "Gas", cost: 45, minutesAgo: 1, context: context)
            createPostWithText(item: "Books", cost: 22, minutesAgo: 2, context: context)
            createPostWithText(item: "Shoes", cost: 657, minutesAgo: 3, context: context)
            createPostWithText(item: "Glasses", cost: 2347, minutesAgo: 4, context: context)



            do {
               try (context.save()) 
            } catch let err{
                print (err)
            }
            
            //posts = [postPetrol, postShirt]
 
        }
        
        loadData()
        
    }
    
    private func createPostWithText(item: String, cost: Double, minutesAgo: Double, context: NSManagedObjectContext) {
        let post = NSEntityDescription.insertNewObject(forEntityName: "Post", into: context) as! Post
        post.item = item
        post.cost = cost
        post.date = NSDate().addingTimeInterval(-minutesAgo * 60)
    }
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            do {
                posts = try (context.fetch(fetchRequest)) as? [Post]

            } catch let err{
                print (err)
            }
        }
    }
    
    
}
