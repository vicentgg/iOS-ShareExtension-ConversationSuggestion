//
//  ViewController.swift
//  iOS-ShareExtension-ConversationSuggestion
//
//  Created by Aakash Shrestha on 20/10/2023.
//

import UIKit
import Intents

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

