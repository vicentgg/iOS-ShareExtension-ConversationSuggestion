//
//  AppSuggShareController.swift
//  ShareExtension
//
//  Created by Aakash Shrestha on 20/10/2023.
//

import UIKit

class AppSuggShareController: UIViewController {

    var dismiss:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismiss?()
    }
}

