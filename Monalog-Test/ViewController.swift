//
//  ViewController.swift
//  Monalog-Test
//
//  Created by Benjamin Lim on 9/12/2016.
//  Copyright © 2016 Benjamin Lim. All rights reserved.
//

import UIKit

let cellId = "cellId"


class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posts:[Post]?
    
    let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()

        navigationItem.title = "FINN"
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
    
        collectionView?.collectionViewLayout = collectionViewFlowLayout
 
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = posts?.count{
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        
        if let post = posts?[indexPath.item] {
            feedCell.post = post
        }
        
        return feedCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        

        return CGSize(width: view.frame.width, height: 60)
    }
    
}

class FeedCell: BaseCell {
    
    var post: Post? {
        didSet {
            
            if let item = post?.item {
                itemTextView.text = item
            }
            
            if let cost = post?.cost {
                costTextView.text = "$\(cost)"
            }
            
            
        }
    }
    
    let nameLabel = { () -> UILabel in
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    
    
    let itemTextView: UILabel = {
        let textView = UILabel()
        textView.text = "ITEM NAME"
        textView.font = UIFont.systemFont(ofSize: 20)
        return textView
    }()
    
    let costTextView: UILabel = {
        let textView = UILabel()
        textView.text = "PRICE"
        textView.font = UIFont.systemFont(ofSize: 20)
        return textView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "TIME"
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
 
    static func buttonForTitle(title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.rgb(red: 143, green: 150, blue: 163), for: .normal)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor.white
        
        
        //subviews
        addSubview(itemTextView)
        addSubview(costTextView)
        addSubview(dividerLineView)
    
        addConstraintsWithFormat(format: "H:|-20-[v0]", views: itemTextView)
        addConstraintsWithFormat(format: "H:[v0]-20-|", views: costTextView)
        
        addConstraintsWithFormat(format: "V:[v0]", views: itemTextView)
        addConstraintsWithFormat(format: "V:[v0]", views: costTextView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: dividerLineView)
        addConstraintsWithFormat(format: "V:[v0(0.5)]|", views: dividerLineView)

        
        addConstraint(NSLayoutConstraint(item: itemTextView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: costTextView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
    
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}




