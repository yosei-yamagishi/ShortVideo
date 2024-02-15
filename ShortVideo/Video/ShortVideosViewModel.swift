import Foundation
import Combine

class ShortVideosViewModel: UDFViewModel {
    enum Action {
        case viewDidLoad
        case viewWillAppear
        case playVideo
        case mute
        case like
        case playOrPause
        case setCurrentIndex(currentIndex: Int)
        case didChangeVideo(currentIndex: Int)
    }
    
    struct State {
        var videos: [Video] = Video.sampleVideos()
        var isMuted: Bool = false
        var isLiked: Bool = false
        var currentIndex: Int = 0
        var currentSecondTime: Float = 0
        var isPlaying: Bool? = nil
    }
    
    @Published var state: State
    private var videoPlayer: VideoPlayerControlProtocol
    private var timer: Timer?
    
    init(
        state: State = State(),
        videoPlayer: VideoPlayerControlProtocol = VideoPlayer()
    ) {
        self.state = state
        self.videoPlayer = videoPlayer
    }
    
    func send(_ action: Action) {
        switch action {
        case .viewDidLoad:
            initAndSetupPlayer()
        case .viewWillAppear:
            playVideo()
        case let .setCurrentIndex(currentIndex):
            self.state.currentIndex = currentIndex
        case .playVideo:
            playVideo()
        case .mute:
            state.isMuted.toggle()
            videoPlayer.mute(isMuted: state.isMuted)
        case .like:
            state.isLiked.toggle()
        case .playOrPause:
            videoPlayer.playOrPause()
            state.isPlaying = videoPlayer.isPlaying
        case .didChangeVideo(currentIndex: let currentIndex):
            initAndSetupPlayer(
                currentIndex: currentIndex
            )
        }
    }
}

extension ShortVideosViewModel {
    private func startTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.01,
            repeats: true
        ) { [weak self] timer in
            guard let self else { return }
            self.state.currentSecondTime = self.videoPlayer.currentTime
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension ShortVideosViewModel {
    private func initAndSetupPlayer(currentIndex: Int = 0) {
        stopTimer()
        videoPlayer.pauseAndInit()
        let url = state.videos[currentIndex].videoUrl
        videoPlayer.prepare(url: url)
    }
    
    private func playVideo() {
        startTimer()
        videoPlayer.play(isMuted: state.isMuted)
        state.isPlaying = videoPlayer.isPlaying
    }
}
