//
//  FavoritesView.swift
//  MoviesReviewsAISwiftUI
//
//  Created by Kevinho Morales on 23/4/25.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: FavoritesViewModel

    init() {
        _viewModel = StateObject(wrappedValue: FavoritesViewModel())
    }

    var body: some View {
        NavigationView {
            if viewModel.favorites.isEmpty {
                VStack {
                    Image(systemName: "heart.slash")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                    Text("Aún no tienes películas guardadas en favoritos.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Favoritos")
            } else {
                List {
                    ForEach(viewModel.favorites, id: \.self) { movie in
                        VStack(spacing: 16) {
                            if let coverURL = movie.coverImageURL, let url = URL(string: coverURL) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 80, height: 120)
                                    case .success(let image):
                                        image.resizable()
                                             .aspectRatio(contentMode: .fill)
                                             .frame(width: 80, height: 120)
                                             .clipped()
                                    case .failure(_):
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 80, height: 120)
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 80, height: 120)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                Text(movie.title ?? "Sin título")
                                    .font(.headline)
                                Text("\(movie.year ?? "") · \(movie.genre ?? "")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(movie.movieDescription ?? "")
                                    .font(.body)
                                    .lineLimit(4)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .onDelete(perform: viewModel.deleteMovies)
                }
                .navigationTitle("Favoritos")
                .onAppear {
                    viewModel.fetchFavorites()
                }
            }
        }
    }
}
#Preview {
    FavoritesView()
}
