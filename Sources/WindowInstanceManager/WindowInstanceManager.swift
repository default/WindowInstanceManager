import UIKit

public protocol WindowControlInterface {
    var uiWindow: UIWindow? { get }
    func close()
}

public protocol WindowInstanceManaging {
    func presentNew(withRoot controller: UIViewController) -> WindowControlInterface
}

public final class WindowInstanceManager {
    // MARK: Singleton
    public static func shared(for application: UIApplication) -> WindowInstanceManaging {
        guard let instance = instance else {
            instance = WindowInstanceManager(application: application)
            return instance!
        }
        
        return instance
    }
    private static var instance: WindowInstanceManager?
    
    // MARK: Properties
    private let application: UIApplication
    private var instances = [UUID: Window]()
    
    // MARK: Initializers
    private init(
        application: UIApplication
    ) {
        self.application = application
    }
}

// MARK: - WindowInstanceManaging
extension WindowInstanceManager: WindowInstanceManaging {
    public func presentNew(withRoot controller: UIViewController) -> WindowControlInterface {
        let window = Window(
            application: application,
            rootController: controller
        )
        
        instances[window.id] = window
        window.delegate = self
        
        window.uiWindow?.makeKeyAndVisible()
        
        return window
    }
}

// MARK: - WindowDelegate
extension WindowInstanceManager: WindowDelegate {
    func close(window: Window) {
        guard let uiWindow = window.uiWindow else {
            return
        }
        
        if let resigned = window.resignedKeyWidnow {
            resigned.makeKeyAndVisible()
        } else {
            application.windows.last?.makeKeyAndVisible()
        }
        
        uiWindow.resignKey()
        uiWindow.isHidden = true
        
        instances[window.id] = nil
    }
}
