import Foundation

extension NSObject {
    @nonobjc static var className: String {
        String(describing: self)
    }

    var className: String {
        type(of: self).className
    }
}
