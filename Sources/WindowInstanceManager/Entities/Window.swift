//
//  Window.swift
//  Created by Nikita Mikheev on 26.02.2022.
//

import UIKit

protocol WindowDelegate: AnyObject {
    func close(window: Window)
}

final class Window {
    // MARK: Delegate
    weak var delegate: WindowDelegate?
    
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

// MARK: - WindowControlInterface
extension Window: WindowControlInterface {
    func close() {
        delegate?.close(window: self)
    }
}
