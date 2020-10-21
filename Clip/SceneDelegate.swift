//
//  SceneDelegate.swift
//  Clip
//
//  Created by Serge Gainsbourg on 9/7/20.
//  Copyright © 2020 IKSong. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let contentView = ContentView(model: modelFrom(connectionOptions.userActivities.first))

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func modelFrom(_ activity: NSUserActivity?) -> IntroModel {
            
        guard activity != nil else { return .atm }
        guard activity!.activityType == NSUserActivityTypeBrowsingWeb else { return .atm }
        guard let incomingURL = activity?.webpageURL else { return .atm }
        guard let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else { return .atm }
        guard let path = components.path else { return .atm }

        print(path)
        return IntroModel.init(withPath: path) ?? .atm
    }

}

