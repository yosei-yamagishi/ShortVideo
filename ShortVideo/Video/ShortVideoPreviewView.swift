import UIKit
import AVKit

class ShortVideoPreviewView: NibLoadableView {
    private var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
    
    private var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    func setupPlayer(
        avPlayer: AVPlayer?
    ) {
        self.player = avPlayer
        playerLayer.videoGravity = .resizeAspectFill
    }
    
    func removePlayer() {
        self.player = nil
    }
}
