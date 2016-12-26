//
//  CustomTabBarController.swift
//  Monalog-Test
//
//  Created by Benjamin Lim on 9/12/2016.
//  Copyright © 2016 Benjamin Lim. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: feedController)
        navigationController.title = ""
        navigationController.tabBarItem.image = UIImage(named: "expenses")
        
        let finnVC = FinnController(collectionViewLayout: UICollectionViewFlowLayout())
        let finnNavigationController = UINavigationController(rootViewController: finnVC)
        finnNavigationController.title = ""
        finnNavigationController.tabBarItem.image = UIImage(named: "finn_logo_2")
        
        let graphsVC = UIViewController()
        let graphsNavigationController = UINavigationController(rootViewController: graphsVC)
        graphsNavigationController.title = ""
        graphsNavigationController.tabBarItem.image = UIImage(named: "graphs")
        
        viewControllers = [navigationController, finnNavigationController, graphsNavigationController]
        
        tabBar.isTranslucent = false
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor.rgb(red: 229, green: 231, blue: 235).cgColor
        
        tabBar.clipsToBounds = true
        tabBar.layer.addSublayer(topBorder)
        
        let view = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0)
        )
        view.backgroundColor = UIColor.FinnGreen()
        
        self.view.addSubview(view)
    }
}


