//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Aakash Shrestha on 20/10/2023.
//

import UIKit
import Intents
import IntentsUI
import MobileCoreServices

class ShareViewController: UIViewController {

    private let selectImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let selectTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        
        let intent = self.extensionContext?.intent as? INSendMessageIntent
        if intent != nil {
            let conversationIdentifier = intent!.conversationIdentifier
            print("\nconversationIdentifier: \(conversationIdentifier as Any)")
            selectTitle.text = conversationIdentifier
        }
        
        guard let inputItems = self.extensionContext?.inputItems as? [NSExtensionItem], inputItems.count > 0 else {
            return
        }
        inputItems.forEach {
            if let attachments = $0.attachments {
                attachments.forEach {
                    // 参考类型转换https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html#//apple_ref/doc/uid/TP40009259-SW1
                    // 图片类型
                    if $0.hasItemConformingToTypeIdentifier(kUTTypePNG as String) {
                        $0.loadItem(forTypeIdentifier: kUTTypePNG as String) { [weak self] item, _ in
                            if let item {
                                if let nsData = item as? NSData {
                                    self?.selectImage.image = UIImage(data: nsData as Data)
                                }
                            }
                        }
                    // URL类型
                    } else if $0.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                        
                    }
                }
            }
        }
    }
    
//    function to display pop up
    func closeShare() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.dismiss(animated:true, completion: nil)
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }
    
    private func setupSubviews() {
        view.backgroundColor = .white
        view.addSubview(selectImage)
        view.addSubview(selectTitle)
        
        NSLayoutConstraint.activate([
            selectImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            selectImage.heightAnchor.constraint(equalToConstant: 100),
            selectImage.widthAnchor.constraint(equalToConstant: 100),
            
            selectTitle.topAnchor.constraint(equalTo: selectImage.bottomAnchor, constant: 20),
            selectTitle.heightAnchor.constraint(equalToConstant: 40),
            selectTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
