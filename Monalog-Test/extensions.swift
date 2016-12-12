//
//  extensions.swift
//  Monalog-Test
//
//  Created by Benjamin Lim on 12/12/2016.
//  Copyright © 2016 Benjamin Lim. All rights reserved.
//

import Foundation
import UIKit

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


extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha:1)
}
}
