//
//  SearchView.swift
//  MoviesReviewsAISwiftUI
//
//  Created by Kevinho Morales on 23/4/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var selectedTab: Tab = .search

    enum Tab {
        case search, favorites
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                VStack {
                    // Buscador siempre arriba
                    TextField("Search movies...", text: $viewModel.searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onSubmit {
                            viewModel.searchMovie()
                        }

                    // Contenedor para los resultados
                    ScrollView {
                        VStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .padding()
                            } else if let movie = viewModel.movie {
                                MovieDetailView(
                                    movie: movie,
                                    isFavorite: $viewModel.isFavorite,
                                    toggleFavorite: viewModel.toggleFavorite
                                )
                            } else {
                                Text("No existen reviews en este momento.")
                                    .foregroundColor(.secondary)
                                    .padding()
                            }
                        }
                    }
                }
                .navigationTitle("Search")
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(Tab.search)

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
                .tag(Tab.favorites)
        }
    }
}

struct MovieDetailView: View {
    let movie: Movie
    @Binding var isFavorite: Bool
    let toggleFavorite: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let url = URL(string: movie.coverImageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    if case .empty = phase {
                                        // Placeholder here if desired
                                    }
                                }
                            }
                    case .success(let image):
                        image.resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(maxWidth: .infinity)
                    case .failure(_):
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.gray)
                    @unknown default:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.gray)
                    }
                }
            }

            Text(movie.title)
                .font(.title)
                .bold()
                .padding(.top)

            Text("\(movie.year) · \(movie.genre)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text(movie.description)
                .font(.body)
                .padding(.top, 5)

            Button(action: toggleFavorite) {
                HStack {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                    Text(isFavorite ? "Quitar de Favoritos" : "Agregar a Favoritos")
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            .padding(.top)
        }
        .padding()
    }
}

#Preview {
    SearchView()
}
