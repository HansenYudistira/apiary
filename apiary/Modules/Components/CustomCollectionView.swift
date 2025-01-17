import UIKit

internal class CustomCollectionView: UICollectionView {
    internal let identifier: String

    init(
        axis: UICollectionView.ScrollDirection,
        cellIdentifier: String,
        frame: CGRect = .zero) {
            identifier = cellIdentifier
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = axis
            super.init(frame: frame, collectionViewLayout: layout)
            self.translatesAutoresizingMaskIntoConstraints = false
            self.showsVerticalScrollIndicator = false
            self.showsHorizontalScrollIndicator = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
