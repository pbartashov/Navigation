//
//  VideoTrack.swift
//  Navigation
//
//  Created by Павел Барташов on 16.07.2022.
//

import Foundation

struct VideoTrack {
    let title: String?
    let videoID: String?
}

extension VideoTrack {
    static var demoVideos: [VideoTrack] { [
        VideoTrack(title: "Navigation View in SwiftUI", videoID: "fHtF7BQLlAU"),
        VideoTrack(title: "SwiftUI Gauge in App", videoID: "YU4eyLiDahg"),
        VideoTrack(title: "Creating Alerts in SwiftUI", videoID: "NPCTUcW8SNQ"),
        VideoTrack(title: "Color Picker in SwiftUI", videoID: "R9bbsjTC3PU"),
        VideoTrack(title: "SwiftUI To Do List for Beginners", videoID: "a1KuQs5dw24"),
    ] }
}
