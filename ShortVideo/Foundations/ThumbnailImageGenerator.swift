import AVFoundation
import UIKit

struct ThumbnailImageGenerator {
    private let asset: AVAsset
    private let generator: AVAssetImageGenerator
    
    init(url: URL) {
        asset = AVAsset(url: url)
        generator = AVAssetImageGenerator (asset: asset)
    }
    
    func updateThumbnail(
        currentSecond: Float
    ) async throws -> UIImage? {
        if #available(iOS 16, *) {
            let secondTime = CMTime(
                seconds: Double(currentSecond),
                preferredTimescale: 1
            )
            let thumbnail = try await generator.image(at: secondTime).image
            generator.requestedTimeToleranceBefore = .zero
            generator.requestedTimeToleranceAfter = .zero
            return UIImage (cgImage: thumbnail)
        } else {
           return nil
        }
    }
}
