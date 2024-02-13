import UIKit

protocol ShortVideoContentViewDelegate: AnyObject {
    func mute()
    func like()
    func playOrPause()
}

class ShortVideoContentView: NibLoadableView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton! {
        didSet {
            let action = UIAction { [weak self] _ in
                self?.delegate?.like()
            }
            likeButton.addAction(
                action,
                for: .touchUpInside
            )
        }
    }
    @IBOutlet weak var playImageView: UIImageView! {
        didSet {
            playImageView.image = nil
        }
    }
    
    @IBOutlet weak var playOrPauseView: UIView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(playOrPause)
            )
            playOrPauseView.addGestureRecognizer(tapGesture)
            playOrPauseView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var muteButton: UIButton! {
        didSet {
            let action = UIAction { [weak self] _ in
                self?.delegate?.mute()
            }
            muteButton.addAction(
                action,
                for: .touchUpInside
            )
        }
    }
    
    weak var delegate: ShortVideoContentViewDelegate?
    
    func setVideo(video: Video) {
        titleLabel.text = video.title
        descriptionLabel.text = video.description
    }
    
    func setMuteImage(isMuted: Bool) {
        let muteImage = isMuted
            ? UIImage(systemName: "speaker.slash")
            : UIImage(systemName: "speaker.wave.2")
        self.muteButton.setImage(
            muteImage,
            for: .normal
        )
    }
    
    func setLikeImage(isLiked: Bool) {
        let likeImage = isLiked
            ? UIImage(systemName: "heart.fill")
            : UIImage(systemName: "heart")
        self.likeButton.setImage(
            likeImage,
            for: .normal
        )
    }
    
    func setPlayImage(isPlaying: Bool?) {
        if let isPlaying = isPlaying {
            let playImage: UIImage? = isPlaying
                ? nil
                : UIImage(systemName: "play.fill")
            self.playImageView.image = playImage
            
            playImageView.alpha = 0.5

            // 影の設定
            self.playImageView.layer.shadowColor = UIColor.black.cgColor // 影の色
            self.playImageView.layer.shadowOpacity = 0.7 // 影の不透明度
            self.playImageView.layer.shadowOffset = CGSize(width: 4, height: 4) // 影のオフセット
            self.playImageView.layer.shadowRadius = 5 // 影のぼかし半径
            self.playImageView.layer.masksToBounds = false
        } else {
            self.playImageView.image = nil

            // 影をクリア
            self.playImageView.layer.shadowOpacity = 0
        }
    }
    
    @objc private func playOrPause() {
        delegate?.playOrPause()
    }
}
