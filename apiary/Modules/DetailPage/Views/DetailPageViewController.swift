import UIKit

internal class DetailPageViewController: UIViewController {
    private let viewModel: DetailPageViewModelProtocol

    init(viewModel: DetailPageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
    }
}
