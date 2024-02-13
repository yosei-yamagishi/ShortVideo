import Foundation
import UIKit

protocol NibLoadable: NSObjectProtocol {
    var nibContainerView: UIView { get }
    func loadNib() -> UIView
    func setupNib()
    var nibName: String { get }
}

extension NibLoadable where Self: UIView {
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let view = bundle.loadNibNamed(
            nibName,
            owner: self,
            options: nil
        )!.first as! UIView
        return view
    }
    
    func setupView(_ view: UIView, inContainer container: UIView) {
        container.backgroundColor = .clear
        let constraints: [NSLayoutConstraint] = [
            view.topAnchor.constraint(equalTo: container.topAnchor),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ]
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
}

class NibLoadableView: UIView, NibLoadable {
    var nibContainerView: UIView {
        self
    }
    
    var nibName: String {
        String(describing: type(of: self))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNib()
    }
    
    func setupNib() {
        setupView(loadNib(), inContainer: nibContainerView)
    }
}
