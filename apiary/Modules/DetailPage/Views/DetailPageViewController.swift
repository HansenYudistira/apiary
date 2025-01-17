import UIKit

internal class DetailPageViewController: UIViewController {
    private let viewModel: DetailPageViewModelProtocol
    private let tagIdentifier: String = "TagCollectionViewCell"
    private var uniqueTag: [String] = []
    private var viewItemListModel: ItemListModel?
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>?
    
    private enum Section {
        case tags
    }

    lazy var tagCollectionView: UICollectionView = {
        let collectionView = CustomCollectionView(axis: .horizontal, cellIdentifier: tagIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            collectionView, indexPath, tag in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: self.tagIdentifier,
                    for: indexPath
                ) as? TagCellView else {
                    return UICollectionViewCell()
                }
                cell.configure(with: tag)
                return cell
        }
        collectionView.register(TagCellView.self, forCellWithReuseIdentifier: tagIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tagCollectionView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    lazy var gradientBackground: GradientBackgroundView = GradientBackgroundView()

    init(viewModel: DetailPageViewModelProtocol) {
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
        updateDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tagCollectionView.collectionViewLayout.invalidateLayout()
        tagCollectionView.layoutIfNeeded()
    }
    
    private func fetchData() {
        uniqueTag = viewModel.fetchUniqueTag()
    }

    private func setupView() {
        view.addSubview(gradientBackground)
        view.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tagCollectionView.heightAnchor.constraint(equalToConstant: 50.0),
            gradientBackground.topAnchor.constraint(equalTo: view.topAnchor),
            gradientBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gradientBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.tags])
        snapshot.appendItems(uniqueTag, toSection: .tags)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension DetailPageViewController: UICollectionViewDelegateFlowLayout {
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
