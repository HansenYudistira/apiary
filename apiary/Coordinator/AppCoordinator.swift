import UIKit

enum Destination {
    case homePage
    case itemListPage(ItemCategoryModel)
    case detailPage(ItemListModel)
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
            let vc = moduleAssembler.assemble(module: homePageModule, coordinator: self, parameters: "")
            navigationController.pushViewController(vc, animated: true)
        case .itemListPage(let categoryModel):
            let itemListPageModule = ItemListPageModule()
            let vc = moduleAssembler.assemble(module: itemListPageModule, coordinator: self, parameters: categoryModel)
            navigationController.pushViewController(vc, animated: true)
        case .detailPage(let itemListModel):
            let detailPageModule = DetailPageModule()
            let vc = moduleAssembler.assemble(module: detailPageModule, coordinator: self, parameters: itemListModel)
            navigationController.pushViewController(vc, animated: true)
        }
    }
}
