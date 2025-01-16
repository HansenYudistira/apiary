import UIKit

protocol Module {
    associatedtype ViewController: UIViewController
    associatedtype Parameters
    func assemble(parameters: Parameters) -> ViewController
}

internal class ModuleAssembler {
    internal func assemble<T: Module>(
        module: T,
        parameters: T.Parameters
    ) -> T.ViewController {
        return module.assemble(parameters: parameters)
    }
}

internal struct HomePageModule: Module {
    internal func assemble(parameters: String = "") -> HomePageViewController {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5.0
        let session = URLSession(configuration: configuration)
        let contract = HomePageViewModelContract(
            networkManager: NetworkManager(urlSession: session),
            dataDecoder: DataDecoder(),
            urlConstructor: URLConstructor()
        )
        let vm = HomePageViewModel(contract: contract)
        let viewController = HomePageViewController(viewModel: vm)
        return viewController
    }
}
