import UIKit
import Combine

internal class ItemListPageViewController: UIViewController {
    private let viewModel: ItemListPageViewModelProtocol
    private var viewItemListModel: [ViewItemListModel] = []
    private var tags: [String] = []
    private var cancellables: Set<AnyCancellable> = []

    enum Section {
        case main
        case tags
    }
    private var dataSource: UITableViewDiffableDataSource<Section, ViewItemListModel>?
    private var tagsDataSource: UICollectionViewDiffableDataSource<Section, String>?
    lazy var searchBarController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = LocalizedKey.search.localized
        searchController.searchBar.showsCancelButton = true
        return searchController
    }()
    lazy var tagCollectionView: UICollectionView = {
        let collectionView = CustomCollectionView(axis: .horizontal, cellIdentifier: TagCellView.identifier)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        tagsDataSource = UICollectionViewDiffableDataSource<Section, String>(
            collectionView: collectionView
        ) { collectionView, indexPath, tag in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TagCellView.identifier,
                for: indexPath
            ) as? TagCellView else {
                return UICollectionViewCell()
            }
            cell.configure(with: tag)
            cell.tagControl.addTarget(self, action: #selector(self.tagControlAction), for: .touchUpInside)
            return cell
        }
        collectionView.register(TagCellView.self, forCellWithReuseIdentifier: TagCellView.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
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
    lazy var gradientBackground: GradientBackgroundView = GradientBackgroundView()

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
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.title = viewModel.fetchTitle()
        navigationItem.searchController = searchBarController
        view.addSubview(gradientBackground)
        view.addSubview(tagCollectionView)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            gradientBackground.topAnchor.constraint(equalTo: view.topAnchor),
            gradientBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gradientBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tagCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tagCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tagCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tagCollectionView.heightAnchor.constraint(equalToConstant: 50),
            tableView.topAnchor.constraint(equalTo: tagCollectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func fetchData() {
        viewItemListModel = viewModel.fetchData()
        tags = viewModel.fetchTags()
        updateItemsDataSource()
        updateTagsDataSource()
    }

    private func updateItemsDataSource() {
        guard let dataSource else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, ViewItemListModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewItemListModel)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

    private func updateTagsDataSource() {
        guard let tagsDataSource else { return }
        var tagSnapshot = NSDiffableDataSourceSnapshot<Section, String>()
        tagSnapshot.appendSections([.tags])
        tagSnapshot.appendItems(tags, toSection: .tags)
        tagsDataSource.apply(tagSnapshot, animatingDifferences: true, completion: nil)
    }

    private func resetTagCollectionCellState() {
        for index in 0..<tagCollectionView.numberOfItems(inSection: 0) {
            if let cell = tagCollectionView.cellForItem(
                at: IndexPath(item: index, section: 0)
            ) as? TagCellView {
                cell.tagControl.isOn = false
            }
        }
    }

    @objc func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel.clearTagsFilter()
            self.viewItemListModel = self.viewModel.fetchData()
            self.updateItemsDataSource()
            self.resetTagCollectionCellState()
            self.refreshControl.endRefreshing()
        }
    }

    @objc func tagControlAction(_ sender: TagControl) {
        guard let label = sender.accessibilityLabel else { return }
        sender.isOn.toggle()
        viewItemListModel = viewModel.fetchFilteredData(with: label, status: sender.isOn)
        updateItemsDataSource()
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
        viewItemListModel = viewModel.searchItems(with: query)
        updateItemsDataSource()
    }
}

extension ItemListPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let cellWidth = collectionViewWidth * 0.3
        return CGSize(width: cellWidth, height: 40)
    }
}
