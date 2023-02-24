//
//  AppDelegate.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var backgroundCompletionHandler:(() -> Void)?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        _ = HFileManager.shared.tempMov
        _ = HFileManager.shared.tempImg
        _ = HFileManager.shared.tempFile
        return true
    }

    func application(_ application: UIApplication,
                     handleEventsForBackgroundURLSession identifier: String,
                     completionHandler: @escaping () -> Void) {
            backgroundCompletionHandler = completionHandler
    }
    
}

