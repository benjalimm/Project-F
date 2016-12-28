//
//  FinnBot.swift
//  Monalog-Test
//
//  Created by Benjamin Lim on 26/12/2016.
//  Copyright © 2016 Benjamin Lim. All rights reserved.
//

import Foundation
import UIKit
import Speech
import CoreData



extension FinnController {
    
    
    func sendTextToApiAI(textRequest: String?) {
        
        let request = ApiAI.shared().textRequest()
        
        if let text = textRequest {
            request?.query = [text]
            print ("\(text) inserted into text query")
        } else {
            request?.query = [""]
        }
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            print ("in completion")
            
            if let response = response as? AIResponse {
                print("AI RESPONSE UNWRAPPED")
                
                //MARK: LOGGING EXPENSE
                if response.result.action == "logExpense" {
                    if let parameters = response.result.parameters as? [String: AIResponseParameter] {
                        
                        if let items = parameters["item"] {
                            
                            print("\(items.stringValue)")
                            self.simulate(text: items.stringValue)
                            
                            if let costs = parameters["unit-currency"] {
                                print("\(costs.stringValue)")
                
                                self.simulate(text: costs.stringValue)
                            }
                            
                        }
                        
                    }
                    
                // MARK: SAYING HI
                } else if response.result.action == "input.welcome" {
                    let text = "Hey there buddy, I'm Finn. Your personal Financial Assistant. You can tell me to log expenses for you (e.g I spent $40 on food, $80 on petrol and $3 on coffee)."
                    self.simulate(text: text)
                    
                // MARK: NOT SURE...
                } else {
                    let text = "I'm not entirely sure what you're saying dude.."
                    self.simulate(text: text)
                }
            }
            print("Left Response block")
            
        }, failure: { (request, error) in
            
            print("Error sending")
        });
        
        ApiAI.shared().enqueue(request) //wtf is this?
        
    }

}
