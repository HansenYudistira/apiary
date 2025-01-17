import UIKit

internal class LoadingView: UIView {
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemGray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
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
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    internal func showLoading() {
        isHidden = false
        activityIndicator.startAnimating()
    }

    internal func hideLoading() {
        isHidden = true
        activityIndicator.stopAnimating()
    }
}
