//
//  ViewController.swift
//  iOS-ShareExtension-ConversationSuggestion
//
//  Created by Aakash Shrestha on 20/10/2023.
//

import UIKit
import Intents

let SuitName: String = "group.wangjin.com.wangjin.share"
let ShareImageKey: String = "kShareImageKey"
let NewShareKey: String = "kNewShareKey"

class ViewController: UIViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(showShareImage), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showShareImage()
    }
    
    @objc
    private func showShareImage() {
        let ud = UserDefaults(suiteName: SuitName)
        if let isNewShareImage = ud?.bool(forKey: NewShareKey), isNewShareImage {
            if let data = ud?.data(forKey: ShareImageKey) {
                imageView.image = UIImage(data: data)
            }
        }
    }

    @IBAction func showIntentButton1(_ sender: Any) {
        generateRecipient(conversationIdentifier: "sampleConversationIdentifier_ID11", displayName: "Prakash Shrestha", img: "image1")
    }
    
    @IBAction func showIntentButton2(_ sender: Any) {
        generateRecipient(conversationIdentifier: "sampleConversationIdentifier_ID22", displayName: "Mohit Shrestha", img: "")
    }
    
    @IBAction func clearIntentButton(_ sender: Any) {
        deleteAllIntent()
    }
    
    func generateRecipient(conversationIdentifier:String, displayName:String, img:String) {
//        Create an INSendMessageIntent to donate an intent for a conversation
//        let conversationID = self.conversationIdentifier?.uuidString
        
        let conversationID = conversationIdentifier
        let groupName = INSpeakableString(spokenPhrase: displayName)
//         Add the user's avatar to the intent.
        let image = INImage(named: "image1")
        
        let sendMessageIntent = INSendMessageIntent(recipients: nil,
                                                    content: nil,
                                                    speakableGroupName: groupName,
                                                    conversationIdentifier: conversationID,
                                                    serviceName: nil,
                                                    sender: nil)
            
        sendMessageIntent.setImage(image, forParameterNamed: \.speakableGroupName)
        
//         Donate the intent.
        let interaction = INInteraction(intent: sendMessageIntent, response: nil)
        interaction.donate(completion: { error in
            if error != nil {
//                 Add error handling here.
            } else {
//                 Do something, for example, send the content to a contact.
                print("INSendMessageIntent has been donated Successfully!!")
            }
        })
    }
    
    func deleteAllIntent() {
        INInteraction.deleteAll { error in
            if error != nil {
                
            } else {
                print("INSendMessageIntent has been deleted Successfully!!")
            }
        }
    }
    
}

