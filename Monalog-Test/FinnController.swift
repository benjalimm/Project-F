//
//  FinnController.swift
//  Monalog-Test
//
//  Created by Benjamin Lim on 10/12/2016.
//  Copyright © 2016 Benjamin Lim. All rights reserved.
//

import UIKit

class FinnController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    
    var messages: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogMessageCell
        
        cell.messageTextView.text = messages?[indexPath.item].text
        if let message = messages?[indexPath.item], let messageText = message.text {
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
            
            if message.isSender == false {
                cell.messageTextView.frame = CGRect(x: 44 + 4, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                
                cell.textBubbleView.frame = CGRect(x: 44 - 10, y: -4, width: estimatedFrame.width + 24 + 16, height: estimatedFrame.height + 26)
                
                cell.profileImageView.isHidden = false
                
                //cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                cell.bubbleImageView.image = ChatLogMessageCell.grayBubbleImage
                cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
                cell.messageTextView.textColor = UIColor.black
            } else {
                //outgoing sending message
                
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 20, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 24 - 24, y: -4, width: estimatedFrame.width + 24 + 16, height: estimatedFrame.height + 20 + 6)
                
                cell.profileImageView.isHidden = true
                
                //cell.textBubbleView.backgroundColor = UIColor.FinnMaroonBlur()
                cell.bubbleImageView.image = ChatLogMessageCell.blueBubbleImage
                cell.bubbleImageView.tintColor = UIColor.FinnMaroonBlur()
                cell.messageTextView.textColor = UIColor.white
                
                
            }

            
        }
        
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.item].text {
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
            
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
}

class ChatLogMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Sample Message"
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "Finn")
        return imageView
    }()
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")?.resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
    
    static let blueBubbleImage = UIImage(named: "bubble_blue")?.resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)

    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ChatLogMessageCell.grayBubbleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        return imageView
    }()
    
    
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        
        addSubview(profileImageView)
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(30)]|", views: profileImageView)
        profileImageView.backgroundColor = UIColor.FinnBlue()
        
        textBubbleView.addSubview(bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "H:|[v0]|", views: bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "V:|[v0]|", views: bubbleImageView)

        


    }
    
    
    
}
