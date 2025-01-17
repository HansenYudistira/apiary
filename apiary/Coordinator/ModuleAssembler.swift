import UIKit

// Used for Assembling Module to be navigated to
protocol Module {
    associatedtype ViewController: UIViewController
    associatedtype Parameters
    func assemble(coordinator: Coordinator, parameters: Parameters) -> ViewController
}

internal class ModuleAssembler {
    internal func assemble<T: Module>(
        module: T,
        coordinator: Coordinator,
        parameters: T.Parameters
    ) -> T.ViewController {
        return module.assemble(coordinator: coordinator, parameters: parameters)
    }
}

internal struct HomePageModule: Module {
    internal func assemble(
        coordinator: Coordinator,
        parameters: String = ""
    ) -> HomePageViewController {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5.0
        let session = URLSession(configuration: configuration)
        let contract = HomePageViewModelContract(
            networkManager: NetworkManager(urlSession: session),
            dataDecoder: DataDecoder(),
            urlConstructor: URLConstructor(),
            coordinator: coordinator
        )
        let vm = HomePageViewModel(contract: contract)
        let viewController = HomePageViewController(viewModel: vm)
        return viewController
    }
}

internal struct ItemListPageModule: Module {
    internal func assemble(
        coordinator: Coordinator,
        parameters: ItemCategoryModel
    ) -> ItemListPageViewController {
        let contract = ItemListPageViewModelContract(
            parameters: parameters,
            coordinator: coordinator
        )
        let vm = ItemListPageViewModel(contract: contract)
        let viewController = ItemListPageViewController(viewModel: vm)
        return viewController
    }
}

internal struct DetailPageModule: Module {
    internal func assemble(
        coordinator: Coordinator,
        parameters: ItemListModel
    ) -> DetailPageViewController {
        let contract = DetailPageViewModelContract(
            parameters: parameters,
            coordinator: coordinator
        )
        let vm = DetailPageViewModel(contract: contract)
        let viewController = DetailPageViewController(viewModel: vm)
        return viewController
    }
}
