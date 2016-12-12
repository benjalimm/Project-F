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
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message"
        return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send"), for: .normal)
        button.tintColor = UIColor.FinnMaroon()
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    func handleSend() {
        print(inputTextField.text)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let message = FinnController.createMessageWithText(text: inputTextField.text!, minutesAgo: 0, context: context, isSender: true)
        
        do {
            try context.save()
            
            messages?.append(message)
            
            let item = messages!.count - 1
            let insertionIndexPath = IndexPath(item: item, section: 0)
            
            collectionView?.insertItems(at: [insertionIndexPath])
            collectionView?.scrollToItem(at: insertionIndexPath, at: .top, animated: true)
        } catch let err {
            print (err)
        }
        
    }
    
    var bottomConstraint: NSLayoutConstraint?
    
    func simulate() {
        print("simulate")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let message = FinnController.createMessageWithText(text: "Here's a text message that was sent a few minutes ago", minutesAgo: 0, context: context)
        
        do {
            try context.save()
            
            messages?.append(message)
            
            messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})

            
            if let item = messages!.index(of: message) {
                let receivingIndexPath = IndexPath(item: item, section: 0)
                collectionView?.insertItems(at: [receivingIndexPath])
                collectionView?.scrollToItem(at: receivingIndexPath, at: .top, animated: true)
            }
            
        } catch let err {
            print (err)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: .plain, target: self, action: #selector(simulate))
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(messageInputContainerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: messageInputContainerView)
        view.addConstraintsWithFormat(format: "V:[v0(48)]", views: messageInputContainerView)

        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        
        messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})
        
        setupInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let indexPath = IndexPath(item: self.messages!.count - 1, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)

    
        }
    
    func handleKeyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            print(keyboardFrame)
            
            let isKeyboardShowing = notification.name == .UIKeyboardWillShow
            
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height + 49 : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { 
                self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    
                    if isKeyboardShowing {
                        let indexPath = NSIndexPath(item: self.messages!.count - 1, section: 0)
                        self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
                    }
                    
                    
            })
            
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    private func setupInputComponents() {
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        
        messageInputContainerView.addConstraintsWithFormat(format: "H:|-8-[v0][v1(60)]|", views: inputTextField, sendButton)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: inputTextField)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: sendButton)



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
        return UIEdgeInsets(top: 8, left: 0, bottom: 49, right: 0)
    }
    
}

class ChatLogMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Sample Message"
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
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
