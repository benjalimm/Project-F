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
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                    let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                    
                    for object in objects! {
                        context.delete(object)
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
            
            
            createFinnMessagesWithContext(context: context)
            
            
            do {
                try (context.save())
            } catch let err{
                print (err)
            }
            
        }
        
        loadData()
        
    }
    static func createMessageWithText(text: String, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) -> Message{
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
        message.isSender = NSNumber(booleanLiteral: isSender) as Bool
        return message 
    }
    
    private func createFinnMessagesWithContext(context: NSManagedObjectContext) {
        FinnController.createMessageWithText(text: "Hey there I'm Finn!", minutesAgo: 5, context: context)
        FinnController.createMessageWithText(text: "Test Message Test Message Test Message Test Message Test Message Test Message!", minutesAgo: 4, context: context)
        FinnController.createMessageWithText(text: "Test Message Test Message Test Message Test Message Test Message Test Message Test Message Test Message Test Message Test Message Test Message Test Message Test Message", minutesAgo: 3, context: context)
         FinnController.createMessageWithText(text: "Test Message Test Message Test Message Test Message Test Message Test Message Test Message Test Message Test Message Test Message Test Message Test Message Test Message", minutesAgo: 1, context: context)
        
        
        //response message
        FinnController.createMessageWithText(text: "I spend $10 on shoes, $60 on petrol, $30 on wood.", minutesAgo: 2, context: context, isSender: true)
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
