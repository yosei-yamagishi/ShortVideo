import AVFoundation

protocol ShortVideoPlayerProtocol {
    var player: AVPlayer? { get }
}

protocol ShortVideoPlayerControlProtocol {
    var isPlaying: Bool { get }
    var currentTime: Float { get }
    var duration: Float { get }
    var delegate: ShortVideoPlayerDelegate? { get set }
    func playOrPause()
    func play()
    func pause()
    func skipForward()
    func skipBackward()
    func setPlaybackRate(rate: Float)
    func setCurrentTime(currentTime: Float)
    func play(isMuted: Bool)
    func pauseAndInit()
    func mute(isMuted: Bool)
    func prepare(url: URL)
}

protocol ShortVideoPlayerDelegate: AnyObject {
    func didPlayToEndTime()
    func didPostIntervalTime(currentSecondTime: Float)
}

class ShortVideoPlayer: ShortVideoPlayerProtocol, ShortVideoPlayerControlProtocol {
    static let timeInterval: TimeInterval = 0.01
    static let skipInterval: Float = 10.0
    
    enum PlaybackRate: Float, CaseIterable {
        static let defaultPlaybackRate: PlaybackRate = .speed100

        case speed075 = 0.75
        case speed100 = 1.0
        case speed125 = 1.25
        case speed150 = 1.5
        case speed175 = 1.75
        case speed200 = 2.0
    }

    private var timerObserver: Any?
    var delegate: ShortVideoPlayerDelegate?
    var player: AVPlayer?
    
    var isPlaying: Bool { player?.isPlaying ?? false }

    var currentTime: Float {
        Float(player?.currentItem?.currentTime().seconds ?? .zero)
    }
    var duration: Float {
        Float(player?.currentItem?.asset.duration.seconds ?? .zero)
    }
    
    func prepare(url: URL) {
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        setupEndPlaybackObserver()
        startObservePlayerTimer()
    }
    
    func playOrPause() {
        isPlaying ? player?.pause() : player?.play()
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func play(isMuted: Bool) {
        mute(isMuted: isMuted )
        player?.play()
    }
    
    func pauseAndInit() {
        NotificationCenter.default.removeObserver(self)
        
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        if let timerObserver {
            player?.removeTimeObserver(
                timerObserver
            )
            self.timerObserver = nil
        }
        player = nil
        delegate = nil
    }
    
    func mute(isMuted: Bool) {
        player?.volume = isMuted ? 0 : 1
    }
    
    func skipForward() {
        let skipedTime = min(
            currentTime + Self.skipInterval,
            duration
        )
        setCurrentTime(currentTime: skipedTime)
    }

    func skipBackward() {
        let skipedTime = max(
            currentTime - Self.skipInterval,
            .zero
        )
        setCurrentTime(currentTime: skipedTime)
    }

    func setCurrentTime(currentTime: Float) {
        player?.seek(
            to: CMTimeMakeWithSeconds(
                Float64(currentTime),
                preferredTimescale: Int32(NSEC_PER_SEC)
            ),
            toleranceBefore: CMTime.zero,
            toleranceAfter: CMTime.zero
        )
    }
    
    func setPlaybackRate(rate: Float) {
        player?.rate = rate
    }
    
    private func startObservePlayerTimer() {
        let intervalTime = CMTimeMakeWithSeconds(
            Self.timeInterval,
            preferredTimescale: Int32(NSEC_PER_SEC)
        )
        timerObserver = player?.addPeriodicTimeObserver(
            forInterval: intervalTime,
            queue: nil,
            using: { [weak self] _ in
                guard let self else { return }
                self.delegate?.didPostIntervalTime(
                    currentSecondTime: self.currentTime
                )
            }
        )
    }

    private func setupEndPlaybackObserver() {
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.delegate?.didPlayToEndTime()
        }
    }
}
