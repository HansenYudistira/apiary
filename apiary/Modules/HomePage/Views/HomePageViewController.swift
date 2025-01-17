import UIKit
import Combine

internal class HomePageViewController: UIViewController {
    private let viewModel: HomePageViewModelProtocol
    private var categoryListModel: [ViewCategoryListModel] = []
    enum Section {
        case main
    }
    private var dataSource: UITableViewDiffableDataSource<Section, ViewCategoryListModel>?
    private var cancellables: Set<AnyCancellable> = []

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CategoryCellView.self, forCellReuseIdentifier: CategoryCellView.identifier)
        tableView.delegate = self
        // Setup Diffable Data Source for Table View
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CategoryCellView.identifier,
                    for: indexPath
                ) as? CategoryCellView
            else {
                fatalError("Could not dequeue MusicCellView")
            }
            let model = self.categoryListModel[indexPath.row]
            cell.configure(with: model)
            return cell
        })
        tableView.refreshControl = self.refreshControl
        return tableView
    }()
    lazy var errorAlert: UIAlertController = {
        let alert = UIAlertController(title: LocalizedKey.error.localized, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizedKey.ok.localized, style: .default))
        return alert
    }()
    lazy var loadingView: LoadingView = LoadingView()
    lazy var gradientBackground: GradientBackgroundView = GradientBackgroundView()

    init(viewModel: HomePageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        viewModel.fetchData()
    }

    private func setupView() {
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.title = LocalizedKey.title.localized
        view.addSubview(gradientBackground)
        view.addSubview(tableView)
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            gradientBackground.topAnchor.constraint(equalTo: view.topAnchor),
            gradientBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gradientBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    /// Swipe Down to Refresh function
    @objc func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel.fetchData()
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: Binding ViewModel State
extension HomePageViewController {
    private func bindViewModel() {
        guard
            let viewModel = viewModel as? HomePageViewModel
        else {
            return
        }
        viewModel.$categoryListModel
            .sink { [weak self] listModel in
                guard let self, let listModel else { return }
                self.categoryListModel = listModel
                self.updateDataSource()
            }
            .store(in: &cancellables)
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self, let errorMessage else { return }
                self.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    self.showLoadingIndicator()
                } else {
                    self.hideLoadingIndicator()
                }
            }
            .store(in: &cancellables)
    }

    private func updateDataSource() {
        guard let dataSource else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, ViewCategoryListModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(categoryListModel)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

    private func showErrorAlert(message: String) {
        errorAlert.message = message
        present(errorAlert, animated: true, completion: nil)
    }

    private func showLoadingIndicator() {
        loadingView.showLoading()
    }

    private func hideLoadingIndicator() {
        loadingView.hideLoading()
    }
}

// MARK: Table View Delegate
extension HomePageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModel = viewModel as? HomePageViewModel else { return }
        viewModel.navigateToItemList(for: categoryListModel[indexPath.row])
    }
}
