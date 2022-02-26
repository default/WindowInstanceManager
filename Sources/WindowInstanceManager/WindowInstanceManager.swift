import UIKit

public struct ManagedWindowReference {
    let id: UUID
}

public protocol WindowInstanceManaging {
    func instance(withRoot controller: UIViewController) -> ManagedWindowReference
    
    func makeKey(_ windowReference: ManagedWindowReference)
    func resign(_ windowReference: ManagedWindowReference)
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
    public func instance(withRoot controller: UIViewController) -> ManagedWindowReference {
        let window = Window(
            application: application,
            rootController: controller
        )
        instances[window.id] = window
        
        return ManagedWindowReference(id: window.id)
    }
    
    public func makeKey(_ windowReference: ManagedWindowReference) {
        guard let window = instances[windowReference.id] else {
            return
        }
        
        window.uiWindow?.makeKeyAndVisible()
    }
    public func resign(_ windowReference: ManagedWindowReference) {
        guard let window = instances[windowReference.id] else {
            return
        }
        
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
