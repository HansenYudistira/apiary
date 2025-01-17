import UIKit

internal class ItemListPageViewController: UIViewController {
    private let viewModel: ItemListPageViewModelProtocol
    private var viewItemListModel: [ViewItemListModel] = []

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
        return tableView
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
}

extension ItemListPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("printed at index \(indexPath.row)")
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
