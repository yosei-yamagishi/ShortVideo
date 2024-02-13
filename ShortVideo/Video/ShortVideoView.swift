import UIKit
import AVKit

class ShortVideoView: NibLoadableView {

    @IBOutlet weak var videoPreviewView: VideoPreviewView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    func setupPlayer(avPlayer: AVPlayer?) {
        videoPreviewView.setupPlayer(avPlayer: avPlayer)
    }
    
    func resetPlayer() {
        videoPreviewView.removePlayer()
    }

    func setupThumbnailImage(urlString: String) {
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.image = UIImage(named: urlString)
    }
    
    func resetImage() {
        thumbnailImageView.image = nil
    }
}
