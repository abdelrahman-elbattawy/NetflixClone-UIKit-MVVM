//
//  YoutubeSearchResponsw.swift
//  Netflix Tutorial
//
//  Created by Aboody on 08/07/2023.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
