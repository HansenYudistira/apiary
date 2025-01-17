import UIKit

internal class CategoryCellView: UITableViewCell {
    static let identifier: String = "CategoryCellView"
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    lazy var itemCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.6, green: 0.6, blue: 0.5, alpha: 1.0).cgColor,
            UIColor(red: 0.7, green: 0.7, blue: 0.6, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.locations = [0.0, 1.0]
        return gradientLayer
    }()
    lazy var shadowView: UIView = {
        let shadowView = UIView()
        shadowView.backgroundColor = .clear
        shadowView.layer.cornerRadius = 8
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowRadius = 4
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        return shadowView
    }()
    lazy var cellView: UIView = {
        let cellView = UIView()
        cellView.backgroundColor = .clear
        cellView.layer.cornerRadius = 8
        cellView.layer.addSublayer(gradientLayer)
        cellView.layer.masksToBounds = true
        cellView.translatesAutoresizingMaskIntoConstraints = false
        return cellView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(shadowView)
        shadowView.addSubview(cellView)
        let mainStackView = UIStackView(arrangedSubviews: [categoryLabel, itemCountLabel])
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        mainStackView.distribution = .fillProportionally
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            cellView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            cellView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -8),
            mainStackView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -8)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    func configure(with model: ViewCategoryListModel) {
        categoryLabel.text = model.name
        itemCountLabel.text = "Item count = \(model.item_count)"
    }
}
