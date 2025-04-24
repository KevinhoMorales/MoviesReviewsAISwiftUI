//
//  SearchViewModel.swift
//  MoviesReviewsAISwiftUI
//
//  Created by Kevinho Morales on 23/4/25.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var movie: Movie?
    @Published var isLoading: Bool = false
    @Published var isFavorite: Bool = false

    func toggleFavorite() {
        isFavorite.toggle()
        if isFavorite {
            addToFavorites()
        } else {
            removeFromFavorites()
        }
    }
    
    private let repository = Repository()
    
    func searchMovie() {
        guard !searchQuery.isEmpty else {
            movie = nil
            return
        }
        isLoading = true
        Task {
            let response = await repository.makeQuestion(searchQuery)
            DispatchQueue.main.async { [weak self] in
                self?.parseResponseAndPrintNames(from: response)
            }
        }
    }
    
    private func parseResponseAndPrintNames(from response: String) {
        let cleaned = response
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .replacingOccurrences(of: "json", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let data = cleaned.data(using: .utf8) else {
            print("Error al convertir a Data")
            DispatchQueue.main.async { [weak self] in self?.isLoading = false }
            return
        }

        do {
            let movie = try JSONDecoder().decode(Movie.self, from: data)
            DispatchQueue.main.async {
                self.movie = movie
                self.isLoading = false
            }
        } catch {
            print("Error al decodificar: \(error)")
            DispatchQueue.main.async { [weak self] in self?.isLoading = false }
        }
    }
    
    func addToFavorites() {
        guard let movie = movie else { return }
        print("Adding movie to favorites: \(movie.title)")
    }
    
    func removeFromFavorites() {
        guard let movie = movie else { return }
        print("Removing movie from favorites: \(movie.title)")
    }
}
