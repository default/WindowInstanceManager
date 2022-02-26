//
//  Window.swift
//  Created by Nikita Mikheev on 26.02.2022.
//

import UIKit

final class Window {
    // MARK: Properties
    let id = UUID()
    
    private(set) var uiWindow: UIWindow?
    private(set) weak var resignedKeyWidnow: UIWindow!
    
    // MARK: Initializers
    init(
        application: UIApplication,
        rootController: UIViewController
    ) {
        guard let applicationWidnow = application.keyWindow else {
            assertionFailure("Application does not have a keyWindow!")
            return
        }
        resignedKeyWidnow = applicationWidnow
        
        uiWindow = UIWindow(frame: UIScreen.main.bounds)
        uiWindow!.rootViewController = rootController
    }
}
