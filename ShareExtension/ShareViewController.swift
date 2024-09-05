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

    private let selectImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let selectTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitle("取消", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(closeShare), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        
        let intent = self.extensionContext?.intent as? INSendMessageIntent
        if intent != nil {
            let conversationIdentifier = intent!.conversationIdentifier
            print("\nconversationIdentifier: \(conversationIdentifier as Any)")
            selectTitleLabel.text = conversationIdentifier
        }
        
        guard let inputItems = self.extensionContext?.inputItems as? [NSExtensionItem], inputItems.count > 0 else {
            return
        }
        inputItems.forEach {
            if let attachments = $0.attachments {
                attachments.forEach {
                    // 参考类型转换https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html#//apple_ref/doc/uid/TP40009259-SW1
                    // 图片类型
                    if $0.hasItemConformingToTypeIdentifier("public.image") {
                        $0.loadItem(forTypeIdentifier: "public.image") { [weak self] data, _ in
                            if let data {
                                let selectImage: UIImage?
                                switch data {
                                case let image as UIImage:
                                    selectImage = image
                                case let data as Data:
                                    selectImage = UIImage(data: data)
                                case let url as URL:
                                    print("url: ", url.path)
                                    selectImage = UIImage(contentsOfFile: url.path)
                                default:
                                    print("Unexpected data:", type(of: data))
                                    selectImage = nil
                                }
                                if Thread.current.isMainThread {
                                    self?.selectImageView.image = selectImage
                                } else {
                                    DispatchQueue.main.async {
                                        self?.selectImageView.image = selectImage
                                    }
                                }
                            }
                        }
                    // URL类型
                    } else if $0.hasItemConformingToTypeIdentifier("public.url") {
                        
                    }
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
    
    @objc
    private func closeShare() {
    }
    
    private func setupSubviews() {
        view.backgroundColor = .white
        view.addSubview(closeButton)
        view.addSubview(selectImageView)
        view.addSubview(selectTitleLabel)
        
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            closeButton.widthAnchor.constraint(equalToConstant: 50),
            
            selectImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor),
            selectImageView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            selectImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            selectTitleLabel.topAnchor.constraint(equalTo: selectImageView.bottomAnchor, constant: 20),
            selectTitleLabel.heightAnchor.constraint(equalToConstant: 40),
            selectTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
