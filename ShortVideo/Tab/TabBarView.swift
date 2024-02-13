import UIKit
import SwiftUI

struct TabBarView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController = UITabBarController()

        let videoPlayer = VideoPlayer()
        let viewModel = ShortVideosViewModel(videoPlayer: videoPlayer)
        let controller = ShortVideosController(
            videoPlayer: videoPlayer,
            viewModel: viewModel
        )
        controller.tabBarItem = UITabBarItem(
            tabBarSystemItem: .favorites,
            tag: 0
        )

        let secondVC = UIViewController()
        secondVC.tabBarItem = UITabBarItem(
            tabBarSystemItem: .history,
            tag: 1
        )

        tabBarController.viewControllers = [controller, secondVC]

        return tabBarController
    }

    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
        // タブバーを更新する必要がある場合、ここで更新します
    }
}
