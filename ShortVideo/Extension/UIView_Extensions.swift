import UIKit

extension UIView {
    func maskCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    func defaultMaskCorner() {
        maskCorner(radius: 6)
    }

    func allMaskCorner() {
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
    
    func border(
        borderWidth: CGFloat = 1,
        borderCGColor: CGColor
    ) {
        layer.borderColor = borderCGColor
        layer.borderWidth = borderWidth
    }
    
    func boarderWithMaskCorner(
        radius: CGFloat = 6,
        borderWidth: CGFloat = 1,
        borderCGColor: CGColor
    ) {
        border(
            borderWidth: borderWidth,
            borderCGColor: borderCGColor
        )
        maskCorner(radius: radius)
    }
}
