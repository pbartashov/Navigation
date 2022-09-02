//
//  Post.swift
//  Navigation
//
//  Created by Павел Барташов on 06.03.2022.
//

public struct Post {
    public let url: String
    public let author: String
    public let description: String
    public let image: String
    public let likes: Int
    public let views: Int

    public init(url: String,
                author: String = "",
                description: String = "",
                image: String = "",
                likes: Int = 0,
                views: Int = 0) {
        
        self.url = url
        self.author = author
        self.description = description
        self.image = image
        self.likes = likes
        self.views = views
    }
}
