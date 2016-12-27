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
            
            createFinnMessageWithContext(context: context)

            do {
                try (context.save())
            } catch let err{
                print (err)
            }
            
        }
        
        loadData()
        
    }
    
    private func createMessageWithText(text: String, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
        message.isSender = NSNumber(value: isSender) as Bool
    }
    
    private func createFinnMessageWithContext(context: NSManagedObjectContext) {
        createMessageWithText(text: "Hey there I'm Finn! I'm your personal artifical intelligent financial assistant :)", minutesAgo: 2, context: context)
        createMessageWithText(text: "You can tell me perform many different kinds of task for you.", minutesAgo: 3, context: context)
        createMessageWithText(text: "For example, if you have a list of expenses you want to log. Simply push the mic button and say: 'I spent $40 on food, $60 on petrol, $30 on clothes and $20 on shoes', and I will log that as 4 different entries for you :)", minutesAgo: 5, context: context)
        
        //response message
        createMessageWithText(text: "I spent $60 on food and $80 on Petrol.", minutesAgo: 7, context: context, isSender: true)
        
    }
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            do {
                messages = try (context.fetch(fetchRequest)) as? [Message]
                print(messages?.count)
                
            } catch let err{
                print (err)
            }
        }
    }
    
    
}
