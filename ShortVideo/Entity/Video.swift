struct Video {
    let title: String
    let description: String
    let thumbnailImageUrlString: String
    let videoUrlString: String
}

extension Video {
    static func sampleVideos() -> [Video] {
        [
            Video(
                title: Sample.title1,
                description: Sample.description1,
                thumbnailImageUrlString: Sample.thumbnailFileName1,
                videoUrlString: Sample.movie1
            ),
            Video(
                title: Sample.title2,
                description: Sample.description2,
                thumbnailImageUrlString: Sample.thumbnailFileName2,
                videoUrlString: Sample.movie2
            ),
            Video(
                title: Sample.title3,
                description: Sample.description3,
                thumbnailImageUrlString: Sample.thumbnailFileName3,
                videoUrlString: Sample.movie3
            ),
            Video(
                title: Sample.title4,
                description: Sample.description4,
                thumbnailImageUrlString: Sample.thumbnailFileName4,
                videoUrlString: Sample.movie4
            ),
            Video(
                title: Sample.title5,
                description: Sample.description5,
                thumbnailImageUrlString: Sample.thumbnailFileName5,
                videoUrlString: Sample.movie5
            )
        ]
    }
}
