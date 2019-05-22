//
//  AppDelegate.swift
//  BitCoin
//
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barTintColor = UIColor(displayP3Red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 30.0) as Any]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 60.0) as Any]
        
        if let navigationController = window?.rootViewController as? UINavigationController,
            let viewController = navigationController.topViewController as? CryptoCurrencyHomeViewController {
            let networking = HTTPNetworking()
            let apiService = CoinDeskAPIService(networking: networking)
            let viewModel = DefaultCryptoCurrencyHomeViewModel(apiService: apiService)
            viewModel.delegate = viewController
            viewController.viewModel = viewModel
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}

