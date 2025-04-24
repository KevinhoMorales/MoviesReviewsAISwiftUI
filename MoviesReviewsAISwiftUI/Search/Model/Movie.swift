//
//  Movie.swift
//  MoviesReviewsAISwiftUI
//
//  Created by Kevinho Morales on 23/4/25.
//

import Foundation

struct Movie: Identifiable, Codable {
    let id = UUID()
    let title: String
    let year: String
    let genre: String
    let description: String
    let coverImageURL: String
}
