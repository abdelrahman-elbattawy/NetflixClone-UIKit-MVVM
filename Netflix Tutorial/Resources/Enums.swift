//
//  Enums.swift
//  Netflix Tutorial
//
//  Created by Aboody on 08/07/2023.
//

import Foundation

enum APIError: Error {
    case failedTogetData
}

enum sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case PopularMovies = 2
    case UpcomingMovies = 3
    case TopRatedMovies = 4
}
