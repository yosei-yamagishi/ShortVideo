import Foundation

struct ShortVideo {
    let title: String
    let description: String
    let thumbnailImageUrlString: String
    let videoUrlString: String
    let secondDuration: Float
    
    var videoUrl: URL {
        Bundle.main.bundleURL
            .appendingPathComponent(videoUrlString)
    }
}

extension ShortVideo {
    static func sampleVideos() -> [ShortVideo] {
        [
            ShortVideo(
                title: Sample.title1,
                description: Sample.description1,
                thumbnailImageUrlString: Sample.thumbnailFileName1,
                videoUrlString: Sample.movie1,
                secondDuration: 9
            ),
            ShortVideo(
                title: Sample.title2,
                description: Sample.description2,
                thumbnailImageUrlString: Sample.thumbnailFileName2,
                videoUrlString: Sample.movie2,
                secondDuration: 4
            ),
            ShortVideo(
                title: Sample.title3,
                description: Sample.description3,
                thumbnailImageUrlString: Sample.thumbnailFileName3,
                videoUrlString: Sample.movie3,
                secondDuration: 7
            ),
            ShortVideo(
                title: Sample.title4,
                description: Sample.description4,
                thumbnailImageUrlString: Sample.thumbnailFileName4,
                videoUrlString: Sample.movie4,
                secondDuration: 7
            ),
            ShortVideo(
                title: Sample.title5,
                description: Sample.description5,
                thumbnailImageUrlString: Sample.thumbnailFileName5,
                videoUrlString: Sample.movie5,
                secondDuration: 8
            )
        ]
    }
}
