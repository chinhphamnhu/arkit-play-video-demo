//
//  AppDelegate.swift
//  DemoArKit
//
//  Created by Chinh Pham N. on 6/12/19.
//  Copyright © 2019 Chinh Pham N. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    var window: UIWindow?

    static let shared: AppDelegate = {
        guard let shared = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Cannot cast `UIApplication.shared.delegate` to AppDelegate")
        }
        return shared
    }()

    // MARK: - Initialize

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        changeRoot(type: .splash)
        return true
    }
}

// MARK: - Change Root

extension AppDelegate {

    // MARK: - Enum

    enum RootType {
        case splash
        case home
    }

    func changeRoot(type: RootType) {
        let controller: UIViewController
        switch type {
        case .splash: controller = SplashViewController()
        case .home: controller = HomeViewController()
        }
        window?.rootViewController = UINavigationController(rootViewController: controller)
    }
}

