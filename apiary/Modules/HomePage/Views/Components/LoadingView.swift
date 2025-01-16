import UIKit

internal class LoadingView: UIView {
    init() {
        super.init(frame: .zero)
        setupLoadingView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLoadingView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        accessibilityLabel = LocalizedKey.loading.localized

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
