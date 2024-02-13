import UIKit

protocol ShortVideoContentViewDelegate: AnyObject {
    func mute()
    func like()
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
}
