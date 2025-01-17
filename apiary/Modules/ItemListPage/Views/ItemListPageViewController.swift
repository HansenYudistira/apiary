import UIKit
import Combine

internal class ItemListPageViewController: UIViewController {
    private let viewModel: ItemListPageViewModelProtocol
    private var viewItemListModel: [ViewItemListModel] = []
    private var cancellables: Set<AnyCancellable> = []

    enum Section {
        case main
    }
    var dataSource: UITableViewDiffableDataSource<Section, ViewItemListModel>?
    lazy var searchBarController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = LocalizedKey.search.localized
        return searchController
    }()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .secondarySystemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ItemListCellView.self, forCellReuseIdentifier: ItemListCellView.identifier)
        tableView.delegate = self
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: ItemListCellView.identifier,
                    for: indexPath
                ) as? ItemListCellView
            else {
                fatalError("Could not dequeue MusicCellView")
            }
            let model = self.viewItemListModel[indexPath.row]
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

    init(viewModel: ItemListPageViewModelProtocol) {
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
        fetchData()
    }

    private func setupView() {
        navigationItem.searchController = searchBarController
        view.backgroundColor = .systemRed
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func fetchData() {
        viewItemListModel = viewModel.fetchData()
        updateDataSource()
    }

    private func updateDataSource() {
        guard let dataSource else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, ViewItemListModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewItemListModel)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    @objc func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewItemListModel = self.viewModel.fetchData()
            self.updateDataSource()
            self.refreshControl.endRefreshing()
        }
    }
}

extension ItemListPageViewController {
    private func bindViewModel() {
        guard
            let viewModel = viewModel as? ItemListPageViewModel
        else {
            return
        }
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self, let errorMessage else { return }
                self.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)
    }

    private func showErrorAlert(message: String) {
        errorAlert.message = message
        present(errorAlert, animated: true, completion: nil)
    }
}

extension ItemListPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModel = viewModel as? ItemListPageViewModel else { return }
        viewModel.navigateToDetail(for: viewItemListModel[indexPath.row])
    }
}

extension ItemListPageViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        guard let query = searchBar.text, !query.isEmpty else {
            return
        }
        /// TODO: filter to searched query
    }
}
