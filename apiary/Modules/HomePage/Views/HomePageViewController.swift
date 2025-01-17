import UIKit
import Combine

internal class HomePageViewController: UIViewController {
    private let viewModel: HomePageViewModelProtocol
    private var categoryListModel: [ViewCategoryListModel] = []
    enum Section {
        case main
    }
    var dataSource: UITableViewDiffableDataSource<Section, ViewCategoryListModel>?
    private var cancellables: Set<AnyCancellable> = []

    lazy var searchBarController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = LocalizedKey.search.localized
        return searchController
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .secondarySystemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CategoryCellView.self, forCellReuseIdentifier: CategoryCellView.identifier)
        tableView.delegate = self
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
        return tableView
    }()
    lazy var errorAlert: UIAlertController = {
        let alert = UIAlertController(title: LocalizedKey.error.localized, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizedKey.ok.localized, style: .default))
        return alert
    }()
    lazy var loadingView: LoadingView = LoadingView()

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
        navigationItem.searchController = searchBarController
        view.backgroundColor = .systemCyan
        view.addSubview(tableView)
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
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
}

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
        loadingView.isHidden = false
    }

    private func hideLoadingIndicator() {
        loadingView.isHidden = true
    }
}

extension HomePageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModel = viewModel as? HomePageViewModel else { return }
        viewModel.navigateToItemList(for: categoryListModel[indexPath.row])
    }
}

extension HomePageViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        guard let query = searchBar.text, !query.isEmpty else {
            return
        }
        /// TODO: filter to searched query
    }
}
