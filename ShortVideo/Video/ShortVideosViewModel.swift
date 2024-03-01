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
        case didEndTracking(value: Float)
    }
    
    struct State {
        var videos: [ShortVideo] = ShortVideo.sampleVideos()
        var isMuted: Bool = false
        var isLiked: Bool = false
        var currentIndex: Int = 0
        var currentSecondTime: Float = 0
        var isPlaying: Bool? = nil
    }
    
    @Published var state: State
    private var videoPlayer: ShortVideoPlayerControlProtocol
    
    init(
        state: State = State(),
        videoPlayer: ShortVideoPlayerControlProtocol = ShortVideoPlayer()
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
        case let .didEndTracking(value: value):
            videoPlayer.setCurrentTime(currentTime: value)
        }
    }
}

extension ShortVideosViewModel: ShortVideoPlayerDelegate {
    func didPlayToEndTime() {
        videoPlayer.setCurrentTime(
            currentTime: .zero
        )
        videoPlayer.play(isMuted: state.isMuted)
    }
    
    func didPostIntervalTime(
        currentSecondTime: Float
    ) {
        state.currentSecondTime = currentSecondTime
    }
}

extension ShortVideosViewModel {
    private func initAndSetupPlayer(currentIndex: Int = 0) {
        videoPlayer.pauseAndInit()
        let url = state.videos[currentIndex].videoUrl
        videoPlayer.prepare(url: url)
        videoPlayer.delegate = self
    }
    
    private func playVideo() {
        videoPlayer.play(isMuted: state.isMuted)
        state.isPlaying = videoPlayer.isPlaying
    }
}
