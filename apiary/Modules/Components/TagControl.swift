import UIKit

// Control that are used in TagCellView
internal class TagControl: UIControl {
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.numberOfLines = 1
        return label
    }()

    internal var isOn: Bool = false {
        didSet {
            updateAppearance()
        }
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupControl()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupControl() {
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        updateAppearance()
    }

    internal func configure(text: String) {
        label.text = text
        accessibilityLabel = text
    }

    internal func resetState() {
        isOn = false
    }

    private func updateAppearance() {
        label.textColor = isOn ? .white : .black
        backgroundColor = isOn ? .systemBlue : .systemGray2
    }
}
