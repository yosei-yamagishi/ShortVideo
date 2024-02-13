import UIKit
import Combine

class ShortVideosController: UIViewController {
    
    @IBOutlet weak var shortVideoCollectionView: ShortVideoCollectionView! {
        didSet {
            shortVideoCollectionView.delegate = self
            shortVideoCollectionView.dataSource = self
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let videoPlayer: VideoPlayerProtocol
    private let viewModel: ShortVideosViewModel

    init(
        videoPlayer: VideoPlayerProtocol = VideoPlayer(),
        viewModel: ShortVideosViewModel
    ) {
        self.videoPlayer = videoPlayer
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.send(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationItem.largeTitleDisplayMode = .never
        
        shortVideoCollectionView.setupVideos(
            videos: viewModel.state.videos
        )
        shortVideoCollectionView.setupPlayer(
            avPlayer: videoPlayer.player
        )
        viewModel.send(.viewWillAppear)
    }
    
    private func bindViewModel() {
        viewModel.$state.map(\.isMuted)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isMuted in
                guard let self else { return }
                self.shortVideoCollectionView.mute(
                    isMuted: isMuted,
                    currentIndex: self.viewModel.state.currentIndex
                )
            }).store(in: &cancellables)
        
        viewModel.$state.map(\.isLiked)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLiked in
                guard let self else { return }
                self.shortVideoCollectionView.like(
                    isLiked: isLiked,
                    currentIndex: self.viewModel.state.currentIndex
                )
            }).store(in: &cancellables)
        
        viewModel.$state.map(\.isPlaying)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isPlaying in
                guard let self else { return }
                self.shortVideoCollectionView.playOrPause(
                    isPlaying: isPlaying,
                    currentIndex: self.viewModel.state.currentIndex
                )
            }).store(in: &cancellables)
    }
}

extension ShortVideosController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.state.videos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as ShortVideoCell
        cell.setShortVideoContentDelegate(
            delegate: self
        )
        cell.setShortVideoContent(
            video:  viewModel.state.videos[indexPath.item]
        )
        cell.setMuteImage(isMuted: viewModel.state.isMuted)
        cell.setLikeImage(isLiked: viewModel.state.isLiked)
        cell.setPlayImage(isPlaying: nil)
        if indexPath.item == viewModel.state.currentIndex {
            cell.setupPlayer(avPlayer: videoPlayer.player)
        } else {
            cell.removePlayer()
        }
        return cell
    }
}

extension ShortVideosController: ShortVideoContentViewDelegate {
    func playOrPause() {
        viewModel.send(.playOrPause)
    }
    
    func mute() {
        viewModel.send(.mute)
    }
    
    func like() {
        viewModel.send(.like)
    }
}

extension ShortVideosController: VideoCollectionViewDelegate {
    func didChangedCollectionPage(currentIndex: Int) {
        viewModel.send(
            .setCurrentIndex(
                currentIndex: currentIndex
            )
        )
        viewModel.send(.didChangeVideo(currentIndex: currentIndex))
        shortVideoCollectionView.setupPlayer(
            avPlayer: videoPlayer.player
        )
        viewModel.send(.playVideo)
    }
}
