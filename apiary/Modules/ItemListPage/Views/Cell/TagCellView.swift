import UIKit

internal class TagCellView: UICollectionViewCell {
    lazy var tagControl: TagControl = TagControl()
    static let identifier: String = "TagCellView"

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(tagControl)

        NSLayoutConstraint.activate([
            tagControl.topAnchor.constraint(equalTo: contentView.topAnchor),
            tagControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tagControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tagControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    internal func configure(with tag: String) {
        tagControl.configure(text: tag)
    }
}
