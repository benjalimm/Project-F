//
//  FinnController.swift
//  Monalog-Test
//
//  Created by Benjamin Lim on 10/12/2016.
//  Copyright © 2016 Benjamin Lim. All rights reserved.
//

import UIKit
import CoreData
import Speech

class FinnController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SFSpeechRecognizerDelegate {
    
    private let cellId = "cellId"
    
    var messages: [Message]?
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.alpha = 0.9
        return view
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "How much have you spent today?.."
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send"), for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    lazy var micButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "mic_button"), for: .normal)
        button.tintColor = UIColor.FinnMaroon()
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var micOrSendButton: UIButton?
    
    //Speech pop-up//
    
    let micView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.white
        view.alpha = 0.97
        return view
    }()
    
    var micTextView: UITextView = {
        let textView = UITextView(frame: UIScreen.main.bounds)
        textView.textColor = UIColor.black
        textView.font = UIFont.systemFont(ofSize: 21)
        let navigationController = UINavigationController()
        let yHeight = UIApplication.shared.statusBarFrame.height + navigationController.navigationBar.frame.height + 70
        textView.frame = CGRect(x: 7, y: yHeight , width: UIScreen.main.bounds.width - 7, height: UIScreen.main.bounds.height)
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    let finnFace: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.FinnBlue()
        imageView.image = UIImage(named: "FinnBig")
        return imageView
    }()
    
    let finnHelpText: UITextField = {
        let textField = UITextField()
        textField.text = "How can I help you buddy?.."
        textField.isEnabled = false
        textField.font = UIFont.boldSystemFont(ofSize: 15)
        textField.textColor = UIColor.gray
        return textField
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "cancel")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor.FinnMaroon()
        button.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var player: AVAudioPlayer?
    
    // Speech pop-up end//
    
    func handleSend() {
        print(inputTextField.text)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        
        if (inputTextField.text?.isEmpty)! {
            return
        } else {
        let message = FinnController.createMessageWithText(text: inputTextField.text!, minutesAgo: 0, context: context, isSender: true)
        sendTextToApiAI(textRequest: inputTextField.text!)

        
        do {
            try context.save()
            
            messages?.append(message)
            
            let item = messages!.count - 1
            let insertionIndexPath = IndexPath(item: item, section: 0)
            
            collectionView?.insertItems(at: [insertionIndexPath])
            collectionView?.scrollToItem(at: insertionIndexPath, at: .top, animated: true)
            inputTextField.text = nil
        } catch let err {
            print (err)
        }
    }
        
    }
    
    func speechSend() {
        print(micTextView.text)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        if micTextView.text.isEmpty {
            return
            
        } else if (micTextView.text != "(Go ahead, im listening...)") {
            
            
            let message = FinnController.createMessageWithText(text: micTextView.text!, minutesAgo: 0, context: context, isSender: true)
            sendTextToApiAI(textRequest: micTextView.text)
            
            do {
                try context.save()
                
                messages?.append(message)
                
                let item = messages!.count - 1
                let insertionIndexPath = IndexPath(item: item, section: 0)
                
                collectionView?.insertItems(at: [insertionIndexPath])
                collectionView?.scrollToItem(at: insertionIndexPath, at: .top, animated: true)
                micTextView.text = nil
                
            } catch let err {
                print (err)
            }
        } else {
            return
        }
        
    }
    
    var bottomConstraint: NSLayoutConstraint?
    
    func simulate(text: String) {
        print("simulate")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let message = FinnController.createMessageWithText(text: text, minutesAgo: 0, context: context)
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
    
    let fetchedResultsController:NSFetchedResultsController<Message> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc as! NSFetchedResultsController<Message>
    }()
    
    //MARK: Speech recogniser -- STARTING POINT OF SPEECH RECOGNITION CODE
    
    private let speechRecognizer = SFSpeechRecognizer()!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    public func askPermission() {
        
    }
    
    // START RECORDING
    func startRecording() throws {
   
        // cancel previous tasks if they are running
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio Engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session. A reference is kept to the task so that it can be cancelled
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) {
            (result, error) in
            
            var isFinal = false
            
            if let result = result {
                self.micTextView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionTask = nil
                
                self.micButton.isEnabled = true
                self.micButton.setTitle("Start Recording", for: [])
            }
            
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer:AVAudioPCMBuffer, when:AVAudioTime) in
            
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
        
        micTextView.text = "(Go ahead, im listening...)"

    }
    func recordButtonTapped() {
        let queue = DispatchQueue(label: "com.finn.app", qos: .userInteractive)

        
        if audioEngine.isRunning {
            queue.async {
                self.playSound()
            }
            speechViewFadeOut()
            audioEngine.stop()
            recognitionRequest?.endAudio()
            micButton.isEnabled = false
            micButton.setTitle("Stopping", for: .disabled)
            speechSend()
        } else {
            speechViewFadeIn()
            try! startRecording()
            micButton.setTitle("Stop Recording", for: [])
            navBarMovesDown()
        }
    }
    
    // MARK: -- ENDING POINT OF SPEECH RECOGNITION CODE
    
    func checkFields() {
        UIView.animate(withDuration: 0, delay: 0, options: [], animations: { 
            if (self.inputTextField.text?.isEmpty)! {
                self.micOrSendButton = self.micButton
            } else {
                self.micOrSendButton = self.sendButton
            }
        }, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Finn"
        
        
        do {
            try fetchedResultsController.performFetch()
            print(fetchedResultsController.sections?[0].numberOfObjects)
        } catch let err {
            print (err)
        }
        
        navigationController?.hidesBarsOnSwipe = true 
        setupData()
        
        micOrSendButton = micButton
        
        micButton.isEnabled = false
        
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        
        view.addSubview(messageInputContainerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: messageInputContainerView)
        view.addConstraintsWithFormat(format: "V:[v0(48)]", views: messageInputContainerView)
        
        
        // SETTING UP OF MIC-VIEW
        view.addSubview(micView)
        let bottom = UIScreen.main.bounds.height
        micView.transform = CGAffineTransform(translationX: 0 , y: bottom)
        micView.addSubview(micTextView)
        micView.addSubview(finnFace)
        micView.addSubview(finnHelpText)
        micView.addSubview(cancelButton)
        micView.addConstraintsWithFormat(format: "H:|-10-[v0(60)]-8-[v1]", views: finnFace,finnHelpText)
        let verticalGap = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)! + 10
        micView.addConstraintsWithFormat(format: "V:|-\(verticalGap)-[v0(60)]", views: finnFace)
        micView.addConstraintsWithFormat(format: "V:|-\(verticalGap + 20)-[v0]", views: finnHelpText)
        let tabBarHeight = CustomTabBarController().tabBar.frame.height + 10
        micView.addConstraintsWithFormat(format: "H:[v0(50)]", views: cancelButton)
        micView.addConstraintsWithFormat(format: "V:[v0(50)]-\(tabBarHeight)-|", views: cancelButton)
        micView.addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .centerX, relatedBy: .equal, toItem: cancelButton.superview, attribute: .centerX, multiplier: 1, constant: 0))
        // -- //
        
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        
        messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})
        
        setupInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkFields), name: NSNotification.Name.UITextFieldTextDidChange, object: inputTextField.text)
        
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
        //messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(micOrSendButton!)

        
        messageInputContainerView.addConstraintsWithFormat(format: "H:|-8-[v0][v1(60)]|", views: inputTextField, micOrSendButton!)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: inputTextField)
        //messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: sendButton)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: micOrSendButton!)
    
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // if let count = fetchedResultsController.sections?[0].numberOfObjects {
        //    return count
        //}
        
        if let count = messages?.count {
        return count
    }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogMessageCell
        
        
        //let message = fetchedResultsController.object(at: indexPath) as! Message

        //print(message?.count)
        
        cell.messageTextView.text = messages?[indexPath.item].text
        if let message = messages?[indexPath.item], let messageText = message.text {
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
            
            if message.isSender == false {
                cell.messageTextView.frame = CGRect(x: 44 + 4, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                
                cell.textBubbleView.frame = CGRect(x: 44 - 10, y: -4, width: estimatedFrame.width + 24 + 16, height: estimatedFrame.height + 26)
                
                cell.profileImageView.isHidden = false
                
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
                cell.bubbleImageView.tintColor = UIColor.MonalogGreen()
                cell.messageTextView.textColor = UIColor.black
                
                
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            OperationQueue.main.addOperation {
                
                switch authStatus {
                case .authorized:
                    self.micButton.isEnabled = true
                    
                    
                case .denied:
                    self.micButton.isEnabled = false
                    self.micButton.setTitle("User denied access to speech recognition", for: .disabled)
                    
                case .restricted:
                    
                    self.micButton.isEnabled = false
                    self.micButton.setTitle("Speech Recognition Restricted", for: .disabled)
                    
                case .notDetermined:
                    
                    self.micButton.isEnabled = false
                    self.micButton.setTitle("Speech recognition not authorised", for: .disabled)
                    
                }
            }
            
        }
    }
   
}

class ChatLogMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Sample Message"
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        textView.isSelectable = false 
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
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
