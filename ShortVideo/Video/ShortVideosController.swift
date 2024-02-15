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
    private var thumbnailImageGenerator: ThumbnailImageGenerator?

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
        
        viewModel.send(.viewWillAppear)
    }
    
    private func bindViewModel() {
        viewModel.$state.map(\.isMuted)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isMuted in
                guard let self else { return }
                self.shortVideoCollectionView.mute(
                    isMuted: isMuted,
                    currentIndex: self.viewModel.state.currentIndex
                )
            }).store(in: &cancellables)
        
        viewModel.$state.map(\.isLiked)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLiked in
                guard let self else { return }
                self.shortVideoCollectionView.like(
                    isLiked: isLiked,
                    currentIndex: self.viewModel.state.currentIndex
                )
            }).store(in: &cancellables)
        
        viewModel.$state.map(\.isPlaying)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isPlaying in
                guard let self else { return }
                self.shortVideoCollectionView.playOrPause(
                    isPlaying: isPlaying,
                    currentIndex: self.viewModel.state.currentIndex
                )
            }).store(in: &cancellables)
        
        viewModel.$state.map(\.currentIndex)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] currentIndex in
                guard let self else { return }
                let video = self.viewModel.state.videos[currentIndex]
                self.shortVideoCollectionView.setup(
                    currentIndex: currentIndex,
                    video: video
                )
                self.thumbnailImageGenerator = ThumbnailImageGenerator(
                    url: video.videoUrl
                )
            }).store(in: &cancellables)
        
        viewModel.$state.map(\.currentSecondTime)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] currentSecondTime in
                guard let self else { return }
                self.shortVideoCollectionView.updateCurrentTime(
                    currentIndex: self.viewModel.state.currentIndex,
                    currentSecondTime: currentSecondTime
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
    func didChangedSliderValue(value: Float) {
        Task.detached {
            do {
                let thumbImage = try await self.thumbnailImageGenerator?.updateThumbnail(currentSecond: value)
                await self.shortVideoCollectionView.setThumbImageForSeeking(
                    currentIndex: self.viewModel.state.currentIndex,
                    thumbImage: thumbImage
                )
            }
        }
    }
    
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
        viewModel.send(.playVideo)
    }
}
