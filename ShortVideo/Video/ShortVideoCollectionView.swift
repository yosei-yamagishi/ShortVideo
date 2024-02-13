import UIKit
import AVKit

protocol VideoCollectionViewDelegate: AnyObject {
    func didChangedCollectionPage(currentIndex: Int)
}

class ShortVideoCollectionView: NibLoadableView {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let followLayout = UICollectionViewFlowLayout()
            followLayout.scrollDirection = collectionLayout.scrollDirection
            collectionView.collectionViewLayout = followLayout
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.isPagingEnabled = true
            collectionView.delegate = self
            let nibs = [ShortVideoCell.self]
            collectionView.registerNib(cellTypes: nibs)
            collectionView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    private var collectionLayout: CollectionLayout {
        CollectionLayout(
            scrollDirection: .vertical,
            insets: .zero,
            minimumLineSpacing: 0,
            minimumInterItemSpacing: 0
        )
    }
    
    private var isDragging: Bool = false
    
    weak var delegate: VideoCollectionViewDelegate?
    weak var dataSource: (UICollectionViewDataSource)? {
        didSet {
            collectionView.dataSource = dataSource
        }
    }
    private var videos: [Video] = []
    private var avPlayer: AVPlayer?
    
    func setupVideos(videos: [Video]) {
        self.videos = videos
        self.collectionView.reloadData()
    }
    
    func setupPlayer(avPlayer: AVPlayer?) {
        self.avPlayer = avPlayer
        self.collectionView.reloadData()
    }
    
    func mute(isMuted: Bool, currentIndex: Int) {
        guard let cell = getShortVideoCell(currentIndex: currentIndex) else { return }
        cell.setMuteImage(isMuted: isMuted)
    }
    
    func like(isLiked: Bool, currentIndex: Int) {
        guard let cell = getShortVideoCell(currentIndex: currentIndex) else { return }
        cell.setLikeImage(isLiked: isLiked)
    }
    
    func playOrPause(isPlaying: Bool?, currentIndex: Int) {
        guard let cell = getShortVideoCell(currentIndex: currentIndex) else { return }
        cell.setPlayImage(isPlaying: isPlaying)
    }
    
    private func getShortVideoCell(
        currentIndex: Int
    ) -> ShortVideoCell? {
        let indexPath = IndexPath(
            item: currentIndex,
            section: 0
        )
        return collectionView.cellForItem(at: indexPath
        ) as? ShortVideoCell
    }
}

extension ShortVideoCollectionView: UICollectionViewDelegate {
    // 画面から指が離れたかつスクロールが自動停止した時
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(round(scrollView.contentOffset.y / frame.size.height))
        delegate?.didChangedCollectionPage(
            currentIndex: currentIndex
        )
    }
}

extension ShortVideoCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        frame.size
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        collectionLayout.insets
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        collectionLayout.minimumInterItemSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        collectionLayout.minimumLineSpacing
    }
}
