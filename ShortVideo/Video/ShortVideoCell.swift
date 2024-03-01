import UIKit
import AVKit

class ShortVideoCell: UICollectionViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removePlayer()
        shortVideoView.resetImage()
    }

    @IBOutlet weak var shortVideoView: ShortVideoView!
    @IBOutlet weak var shortVideoContentView: ShortVideoContentView!
    
    func setShortVideoContentDelegate(
        delegate: ShortVideoContentViewDelegate
    ) {
        shortVideoContentView.delegate = delegate
    }
    
    func setupPlayer(avPlayer: AVPlayer?) {
        shortVideoView.setupPlayer(avPlayer: avPlayer)
    }
    
    func removePlayer() {
        shortVideoView.resetPlayer()
    }

    func setShortVideoContent(video: ShortVideo) {
        shortVideoContentView.setVideo(video: video)
        shortVideoView.setupThumbnailImage(urlString: video.thumbnailImageUrlString)
    }
    
    func setMuteImage(isMuted: Bool) {
        shortVideoContentView.setMuteImage(isMuted: isMuted)
    }
    
    func setLikeImage(isLiked: Bool) {
        shortVideoContentView.setLikeImage(isLiked: isLiked)
    }
    
    func setPlayImage(isPlaying: Bool?) {
        shortVideoContentView.setPlayImage(isPlaying: isPlaying)
    }
    
    func setupSlider(duration: Float) {
        shortVideoContentView.setupVideoSlider(
            duration: duration
        )
    }
    
    func setupThumbImage(thumbImage: UIImage?) {
        shortVideoContentView.setupSliderThumbImage(thumbImage: thumbImage)
    }
    
    func updateCurrentTime(
        currentSecondTime: Float
    ) {
        shortVideoContentView.updateCurrentTime(
            currentSecondTime: currentSecondTime
        )
    }
    
    func openMoreDetail() {
        shortVideoContentView.openMoreDetail()
    }
    
    func closeMoreDetail() {
        shortVideoContentView.closeMoreDetail()
    }
}
