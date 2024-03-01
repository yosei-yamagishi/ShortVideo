import UIKit

protocol ShortVideoContentViewDelegate: AnyObject {
    func mute()
    func like()
    func playOrPause()
    func didChangedSliderValue(value: Float)
    func didEndTracking(value: Float)
}

class ShortVideoContentView: NibLoadableView {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var sliderThumbImage: UIImageView!
    @IBOutlet weak var sliderThumbView: UIView! {
        didSet {
            sliderThumbView.maskCorner(radius: 8)
        }
    }
    @IBOutlet weak var sliderThumbImageBaseView: UIView! {
        didSet {
            sliderThumbImageBaseView.alpha = 0
        }
    }
    @IBOutlet weak var currentTimeView: UIView! {
        didSet {
            currentTimeView.allMaskCorner()
        }
    }
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
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
    @IBOutlet weak var videoSlider: ShortVideoSlider! {
        didSet {
            videoSlider.delegate = self
        }
    }
    
    @IBOutlet weak var moreDetailView: UIView!
    @IBOutlet weak var moreDetailViewHeight: NSLayoutConstraint! {
        didSet {
            moreDetailViewHeight.constant = MoreDetailViewLayout.height
        }
    }
    
    @IBOutlet weak var moreDetailHeaderView: UIView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(toggleMoreDetail)
            )
            moreDetailHeaderView.addGestureRecognizer(tapGesture)
            moreDetailHeaderView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var moreContentView: UIView! {
        didSet {
            moreContentView.alpha = 0
        }
    }
    @IBOutlet weak var moreDetailButton: UIButton! {
        didSet {
            moreDetailButton.border(
                borderCGColor: UIColor.white.cgColor
            )
            moreDetailButton.maskCorner(radius: 6)
        }
    }
    
    struct MoreDetailViewLayout {
        static var height: CGFloat = 40
        static var headerHeight: CGFloat = 40
        static var contentHeight: CGFloat = 76
        
        static func isClosed(height: CGFloat) -> Bool {
            Self.height == height
        }
    }
    
    weak var delegate: ShortVideoContentViewDelegate?
    
    func setVideo(video: ShortVideo) {
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
    
    func updateCurrentTime(
        currentSecondTime: Float
    ) {
        if videoSlider.isTracking {
            return
        }
        videoSlider.value = currentSecondTime
    }
}

extension ShortVideoContentView {
    @objc func toggleMoreDetail() {
        let isClosed = MoreDetailViewLayout.isClosed(height: moreDetailViewHeight.constant)
        isClosed ? openMoreDetail() : closeMoreDetail()
    }
    
    func openMoreDetail() {
        moreDetailViewHeight.constant = MoreDetailViewLayout.contentHeight + MoreDetailViewLayout.height
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.baseView.alpha = 0
            self?.moreContentView.alpha = 1
            self?.layoutIfNeeded()
        }
    }
    
    func closeMoreDetail() {
        moreDetailViewHeight.constant = MoreDetailViewLayout.height
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.baseView.alpha = 1
            self?.moreContentView.alpha = 0
            self?.layoutIfNeeded()
        }
    }
}

extension ShortVideoContentView {
    func setupSliderThumbImage(thumbImage: UIImage?) {
        self.sliderThumbImage.image = thumbImage
    }
    
    func setupVideoSlider(duration: Float) {
        videoSlider.minimumValue = 0
        videoSlider.maximumValue = duration
        currentTimeLabel.text = formatPlayTime(secondTime: 0)
        durationTimeLabel.text = formatPlayTime(secondTime: duration)
    }
    
    private func updateThumbnailImagePoint(slider: UISlider) {

        let trackRect = slider.trackRect(forBounds: slider.bounds)
        let thumbRect = slider.thumbRect(forBounds: slider.bounds, trackRect: trackRect, value: slider.value)
        let thumbCenterX = thumbRect.midX

        // thumbViewの中心をスライダーのつまみの中心に合わせる
        let thumbViewCenterX = max(min(thumbCenterX, frame.width - sliderThumbView.frame.width / 2), sliderThumbView.frame.width / 2)

        sliderThumbView.center = CGPoint(x: thumbViewCenterX, y: sliderThumbView.center.y)
     }
    
    private func formatPlayTime(secondTime: Float) -> String {
        let durationInt = Int(round(secondTime))
        return String(
            format: "%02d:%02d",
            Int(durationInt / 60),
            Int(durationInt % 60)
        )
    }
}

extension ShortVideoContentView: ShortVideoSliderDelegete {
    func beginTracking() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.baseView?.alpha = 0
            self?.moreDetailView.alpha = 0
            self?.sliderThumbImageBaseView.alpha = 1
            self?.videoSlider.transform = CGAffineTransform(scaleX: 0.9, y: 1)
        }
    }
    
    func endTracking(value: Float) {
        baseView.alpha = 1
        moreDetailView.alpha = 1
        sliderThumbImageBaseView.alpha = 0
        videoSlider.transform = .identity
        delegate?.didEndTracking(value: value)
    }
    
    func valueDidChange(value: Float, slider: UISlider) {
        delegate?.didChangedSliderValue(value: value)
        currentTimeLabel.text = formatPlayTime(secondTime: value)
        updateThumbnailImagePoint(slider: slider)
    }
}
