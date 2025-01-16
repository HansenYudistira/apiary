import UIKit

enum Destination {
    case homePage
}

protocol Coordinator {
    func start()
    func navigate(to destination: Destination)
}

internal class AppCoordinator: Coordinator {
    private var navigationController: UINavigationController
    private let moduleAssembler: ModuleAssembler
    
    init(
        navigationController: UINavigationController,
        moduleAssembler: ModuleAssembler = ModuleAssembler()
    ) {
        self.navigationController = navigationController
        self.moduleAssembler = moduleAssembler
    }
    
    internal func start() {
        navigate(to: .homePage)
    }
    
    internal func navigate(to destination: Destination) {
        switch destination {
        case .homePage:
            let homePageModule = HomePageModule()
            let vc = moduleAssembler.assemble(module: homePageModule, parameters: "")
            navigationController.pushViewController(vc, animated: true)
        }
    }
}
