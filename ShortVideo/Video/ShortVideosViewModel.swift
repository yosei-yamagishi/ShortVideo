import Foundation
import Combine

class ShortVideosViewModel: UDFViewModel {
    enum Action {
        case mute
        case like
        case setCurrentIndex(currentIndex: Int)
    }
    
    struct State {
        var videos: [Video] = Video.sampleVideos()
        var isMuted: Bool = false
        var isLiked: Bool = false
        var currentIndex: Int = 0
    }
    
    @Published var state: State
    private var videoPlayer: VideoPlayerControlProtocol
    
    init(
        state: State = State(),
        videoPlayer: VideoPlayerControlProtocol = VideoPlayer()
    ) {
        self.state = state
        self.videoPlayer = videoPlayer
    }
    
    func send(_ action: Action) {
        switch action {
        case let .setCurrentIndex(currentIndex):
            self.state.currentIndex = currentIndex
        case .mute:
            state.isMuted.toggle()
            videoPlayer.mute(isMuted: state.isMuted)
        case .like:
            state.isLiked.toggle()
        }
    }
}

extension ShortVideosViewModel {
    func initAndSetupPlayer(currentIndex: Int = 0) {
        videoPlayer.pauseAndInit()
        let videoUrlString = state.videos[currentIndex].videoUrlString
        let url = Bundle.main.bundleURL
            .appendingPathComponent(videoUrlString)
        videoPlayer.prepare(url: url)
    }
    
    func playVideo() {
        videoPlayer.play(isMuted: state.isMuted)
    }
}
