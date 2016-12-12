//
//  FinnControllerHelper.swift
//  Monalog-Test
//
//  Created by Benjamin Lim on 11/12/2016.
//  Copyright © 2016 Benjamin Lim. All rights reserved.
//

import UIKit
import CoreData

extension FinnController {
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            do {
                let entityNames = ["Message"]
                
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
            
            
            createMessageWithText(text: "Hey there I'm Finn!", minutesAgo: 2, context: context)
            
            
            do {
                try (context.save())
            } catch let err{
                print (err)
            }
            
        }
        
        loadData()
        
    }
    
    private func createMessageWithText(text: String, minutesAgo: Double, context: NSManagedObjectContext) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
    }
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            do {
                messages = try (context.fetch(fetchRequest)) as? [Message]
                
            } catch let err{
                print (err)
            }
        }
    }
    
    
}
