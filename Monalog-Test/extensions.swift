//
//  extensions.swift
//  Monalog-Test
//
//  Created by Benjamin Lim on 12/12/2016.
//  Copyright © 2016 Benjamin Lim. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension UIColor {
    
    static func FinnBlue() -> UIColor {
        return UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1)
    }
    
    static func FinnMaroon() -> UIColor {
        return UIColor(red: 148/255, green: 67/255, blue: 67/255, alpha:1)
    }
    
    static func FinnMaroonBlur() -> UIColor {
        return UIColor(red: 148/255, green: 67/255, blue: 67/255, alpha:0.9)
    }
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha:1)
}
    
    static func MonalogGreen() -> UIColor {
        return UIColor(red: 207/255, green: 238/255, blue: 212/255, alpha: 0.5)
    }
    
    static func FinnGreen() -> UIColor {
        return UIColor(red: 207/255, green: 238/255, blue: 212/255, alpha: 1)
    }
    
    static func Cream() -> UIColor {
        return UIColor(red: 251/255, green: 255/255, blue: 230/255, alpha: 1)
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


extension FinnController {
    
    
    func speechViewFadeIn() {


        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            
            
            self.micView.transform = CGAffineTransform(translationX: 0 , y: 0)
            
            }, completion: nil)
    }
    
    func speechViewFadeOut() {
        let bottom = UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            
        
            self.micView.transform = CGAffineTransform(translationX: 0 , y: bottom)

            
            }, completion: nil)
    }
    
    func playSound() {

            guard let url = Bundle.main.url(forResource: "pop-drip", withExtension: "wav") else {
                print ("url not found")
                return
            }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                
                self.player = try AVAudioPlayer(contentsOf: url)
                
                self.player!.play()
                print ("pop-drip sound played")
                
            } catch let err {
                print (err)
            }

        
    }
    
}
