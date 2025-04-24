import Foundation
import CoreData
import SwiftUI

final class FavoritesViewModel: ObservableObject {
    @Published var favorites: [FavoriteMovie] = []
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        fetchFavorites()
    }

    func fetchFavorites() {
        let request: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FavoriteMovie.title, ascending: true)]

        do {
            favorites = try context.fetch(request)
        } catch {
            print("Error fetching favorites: \(error.localizedDescription)")
            favorites = []
        }
    }

    func deleteMovies(offsets: IndexSet) {
        withAnimation {
            offsets.map { favorites[$0] }.forEach(context.delete)
            do {
                try context.save()
                fetchFavorites() // Refresh list after deletion
            } catch {
                print("Error deleting favorite movie: \(error.localizedDescription)")
            }
        }
    }
}
