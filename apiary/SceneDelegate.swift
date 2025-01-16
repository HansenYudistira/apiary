import UIKit

internal class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    internal var window: UIWindow?
    private var coordinator: AppCoordinator?

    internal func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard
            let windowScene = (scene as? UIWindowScene)
        else {
            return
        }
        self.window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        self.coordinator = AppCoordinator(navigationController: navigationController)
        guard
            let coordinator = coordinator,
            let window = window
        else {
            return
        }
        coordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
