import UIKit

struct CollectionLayout {
    let deviceViewSize: CGSize
    let scrollDirection: UICollectionView.ScrollDirection
    let displayCount: CGFloat
    let nextContentDisplayWidth: CGFloat
    let insets: UIEdgeInsets
    let minimumLineSpacing: CGFloat // 垂直方向におけるセル間のマージン
    let minimumInterItemSpacing: CGFloat // 水平方向におけるセル間のマージン

    init(
        scrollDirection: UICollectionView.ScrollDirection,
        displayCount: CGFloat = 0,
        nextContentDisplayWidth: CGFloat = 0,
        insets: UIEdgeInsets,
        minimumLineSpacing: CGFloat,
        minimumInterItemSpacing: CGFloat,
        viewSize: CGSize = UIScreen.main.bounds.size
    ) {
        self.scrollDirection = scrollDirection
        self.displayCount = displayCount
        self.nextContentDisplayWidth = nextContentDisplayWidth
        self.insets = insets
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInterItemSpacing = minimumInterItemSpacing
        self.deviceViewSize = viewSize
    }
}
