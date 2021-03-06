//
//  ItemChatViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/14/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import ChameleonFramework
import FirebaseDatabase
import FirebaseStorage
import JSQMessagesViewController
import Photos
import ImagePicker
import FirebaseAuth
import Pulley

//Class to manage global chat on an item which any user can join
class ItemChatViewController: JSQMessagesViewController {

    var frame: CGRect?

    var messages = [JSQMessage]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    lazy var storageRef: FIRStorageReference = FIRStorage.storage().reference()

    let imageURLNotSetKey = ""

    var chatRef: FIRDatabaseReference?

    var keyString: String?=nil {
        didSet {
            let notOptional: String = keyString ?? ""
            self.channelRef = FIRDatabase.database().reference().child(currentGroup).child("items").child("\(notOptional)")
            self.messageRef = channelRef?.child("messages")

        }
    }

    var textViewToDismiss: UITextView?

    var pulley: FirstContainerViewController?=nil {
        didSet {
            pulley?.itemChatDelegate = self
        }
    }

    func viewDismissed() {
        self.textViewToDismiss?.resignFirstResponder()
    }

    var messageRef: FIRDatabaseReference?
    var channelRef: FIRDatabaseReference?
    private var newMessageRefHandle: FIRDatabaseHandle?

    lazy var userIsTypingRef: FIRDatabaseReference =
        self.channelRef!.child("typingIndicator").child(self.senderId) // 1
    private var localTyping = false // 2
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            // 3
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }
    lazy var usersTypingQuery: FIRDatabaseQuery =
        self.channelRef!.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)

    var photoMessageMap = [String: JSQPhotoMediaItem]()
    var updatedMessageRefHandle: FIRDatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        observeMessages()
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.frame = self.frame ?? self.view.frame
        observeTyping()

    }

    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }

    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        chatRef?.setValue("👍")
        let itemRef = messageRef?.childByAutoId()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        let dateResult = formatter.string(from: date)
        let messageItem = [
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            ]
        itemRef?.setValue(messageItem)
        messageRef?.parent?.child("chatLastDate").setValue(dateResult)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        isTyping = false
        finishSendingMessage()
    }

    deinit {
        if let refHandle = newMessageRefHandle {
            messageRef?.removeObserver(withHandle: refHandle)
        }

        if let refHandle = updatedMessageRefHandle {
            messageRef?.removeObserver(withHandle: refHandle)
        }
    }

    private func observeMessages() {
        let messagesQuery = messageRef?.queryLimited(toLast: 25)

        newMessageRefHandle = messagesQuery?.observe(.childAdded, with: { (snapshot) -> Void in
            let messageData = snapshot.value as! Dictionary<String, String>

            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
                self.addMessage(withId: id, name: name, text: text)
                self.finishReceivingMessage()
            } else if let id = messageData["senderId"] as String!,
                let photoURL = messageData["photoURL"] as String!,
            let name = messageData["senderName"] as String!{
                if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: id == self.senderId) {
                    self.addPhotoMessage(withId: id, key: snapshot.key, name: name, mediaItem: mediaItem)
                    if photoURL.hasPrefix("gs://") {
                        self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: nil)
                    }
                }
            }
        })
        updatedMessageRefHandle = messageRef?.observe(.childChanged, with: { (snapshot) in
            let key = snapshot.key
            let messageData = snapshot.value as! Dictionary<String, String>

            if let photoURL = messageData["photoURL"] as String! {
                if let mediaItem = self.photoMessageMap[key] {
                    self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: key) // 4
                }
            }
        })
    }
}

//MARK: - Appearnces
extension ItemChatViewController {

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    
    func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.flatNavyBlue)
    }

    func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.flatWatermelon)
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return NSAttributedString(string: currentUser.displayName)
        } else {
            return NSAttributedString(string: message.senderDisplayName, attributes:
                [NSFontAttributeName : Fonts.regular.get(size: 12),
                 NSForegroundColorAttributeName : UIColor.flatGrayDark])
        }
        
    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 18
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]

        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
}

//MARK:- Typing Indicator
extension ItemChatViewController {
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        isTyping = textView.text != ""
    }
    override func textViewDidBeginEditing(_ textView: UITextView) {
        self.textViewToDismiss = textView
    }
    func observeTyping() {
        let typingIndicatorRef = channelRef!.child("typingIndicator")
        userIsTypingRef = typingIndicatorRef.child(senderId)
        userIsTypingRef.onDisconnectRemoveValue()
        usersTypingQuery.observe(.value) { (data: FIRDataSnapshot) in
            if data.childrenCount == 1 && self.isTyping {
                return
            }
            self.showTypingIndicator = data.childrenCount > 0
            self.scrollToBottom(animated: true)
        }
    }
}

//MARK: - Photo sending
extension ItemChatViewController:ImagePickerDelegate {
    func sendPhotoMessage() -> String? {
        let itemRef = messageRef?.childByAutoId()

        let messageItem = [
            "photoURL": imageURLNotSetKey,
            "senderId": senderId!,
            "senderName" : senderDisplayName
            ]

        itemRef?.setValue(messageItem)

        JSQSystemSoundPlayer.jsq_playMessageSentSound()

        finishSendingMessage()
        return itemRef?.key
    }

    override func didPressAccessoryButton(_ sender: UIButton) {
        var config = Configuration()
        config.backgroundColor = UIColor.flatBlue
        config.recordLocation = false
        config.showsImageCountLabel = false
        let picker = ImagePickerController(configuration: config)
        picker.imageLimit = 1
        picker.delegate = self

        present(picker, animated: true, completion:nil)
    }

    func setImageURL(_ url: String, forPhotoMessageWithKey key: String) {
        let itemRef = messageRef?.child(key)
        itemRef?.updateChildValues(["photoURL": url])
    }

    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {}

    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {

        if let key = sendPhotoMessage() {
            // 3
            let imageData = UIImageJPEGRepresentation(images[0], 0.5)
            // 4
            let imagePath = FIRAuth.auth()!.currentUser!.uid + "/\(Int(Date.timeIntervalSinceReferenceDate * 1_000)).jpg"
            // 5
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            // 6
            storageRef.child("chatImages").child(imagePath).put(imageData!, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading photo: \(error)")
                    return
                }
                // 7
                self.setImageURL(self.storageRef.child((metadata?.path)!).description, forPhotoMessageWithKey: key)
            }
        }
        imagePicker.dismiss(animated: true, completion:nil)

    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {    imagePicker.dismiss(animated: true, completion:nil)
    }

    func addPhotoMessage(withId id: String, key: String, name: String, mediaItem: JSQPhotoMediaItem) {
        if let message = JSQMessage(senderId: id, displayName: "", media: mediaItem) {
            messages.append(message)

            if (mediaItem.image == nil) {
                photoMessageMap[key] = mediaItem
            }

            collectionView.reloadData()
        }
    }

    func fetchImageDataAtURL(_ photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?) {
        let storageRef = FIRStorage.storage().reference(forURL: photoURL)

        storageRef.data(withMaxSize: INT64_MAX) { (data, error) in
            if let error = error {
                print("Error downloading image data: \(error)")
                return
            }

            storageRef.metadata(completion: { (_, metadataErr) in
                if let error = metadataErr {
                    print("Error downloading metadata: \(error)")
                    return
                }

                mediaItem.image = UIImage(data: data!)

                self.collectionView.reloadData()

                guard key != nil else {
                    return
                }
                self.photoMessageMap.removeValue(forKey: key!)
            })
        }
    }

}

//MARK :- chat conatiner view adjustments
extension ItemChatViewController:PulleyDelegate {
    func drawerPositionDidChange(drawer: PulleyViewController) {
        if drawer.drawerPosition != .open {
            self.inputToolbar?.isHidden = true
        } else {
            self.inputToolbar?.isHidden = false
            self.textViewToDismiss?.becomeFirstResponder()

        }

    }

}
