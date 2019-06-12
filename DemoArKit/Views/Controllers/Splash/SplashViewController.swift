//
//  SplashViewController.swift
//  DemoArKit
//
//  Created by Chinh Pham N. on 6/12/19.
//  Copyright © 2019 Chinh Pham N. All rights reserved.
//

import UIKit

final class SplashViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var welcomeLabel: UILabel!
    
    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.alpha = 0

        UIView.animate(withDuration: 1) {
            self.welcomeLabel.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            AppDelegate.shared.changeRoot(type: .home)
        }
    }
}
