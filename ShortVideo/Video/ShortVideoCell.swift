import UIKit
import AVKit

class ShortVideoCell: UICollectionViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removePlayer()
        shortVideoView.resetImage()
    }

    @IBOutlet weak var shortVideoView: ShortVideoView!
    @IBOutlet weak var shortContentVideoView: ShortVideoContentView!
    
    func setShortVideoContentDelegate(
        delegate: ShortVideoContentViewDelegate
    ) {
        shortContentVideoView.delegate = delegate
    }
    
    func setupPlayer(avPlayer: AVPlayer?) {
        shortVideoView.setupPlayer(avPlayer: avPlayer)
    }
    
    func removePlayer() {
        shortVideoView.resetPlayer()
    }

    func setShortVideoContent(video: Video) {
        shortContentVideoView.setVideo(video: video)
        shortVideoView.setupThumbnailImage(urlString: video.thumbnailImageUrlString)
    }
    
    func setMuteImage(isMuted: Bool) {
        shortContentVideoView.setMuteImage(isMuted: isMuted)
    }
    
    func setLikeImage(isLiked: Bool) {
        shortContentVideoView.setLikeImage(isLiked: isLiked)
    }
    
    func setPlayImage(isPlaying: Bool?) {
        shortContentVideoView.setPlayImage(isPlaying: isPlaying)
    }
}
