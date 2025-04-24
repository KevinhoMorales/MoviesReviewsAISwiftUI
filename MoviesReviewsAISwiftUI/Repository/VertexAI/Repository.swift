//
//  Repository.swift
//  MoviesReviewsAISwiftUI
//
//  Created by Kevinho Morales on 23/4/25.
//

import Foundation
import FirebaseVertexAI

final class Repository {
    private let vertex = VertexAI.vertexAI()
    private let modelName = "gemini-2.0-flash"

    func makeQuestion(_ prompt: String) async -> String {
        do {
            // Inicializa el modelo generativo con el modelo especificado
            let model = vertex.generativeModel(modelName: modelName)
            
            // Genera contenido basado en el prompt
            let fullPrompt = """
            Genera exclusivamente el siguiente JSON (sin texto adicional, sin explicaciones):

            {
              "title": "Título de la película",
              "year": "Año de la película",
              "genre": "Género de la película",
              "description": "Breve reseña de la película",
              "coverImageURL": "URL de la portada de la película"
            }

            La película es: \(prompt).
            Asegúrate de que el campo 'coverImageURL' sea un enlace directo a una imagen de buena calidad y que realmente exista. Puedes basarte en imágenes disponibles en TMDB (The Movie Database) o sitios de referencia de películas. No inventes URLs ni generes enlaces falsos.
            No incluyas ningún texto fuera de la estructura JSON.
            """
            let response = try await model.generateContent(fullPrompt)
            
            // Retorna el texto generado o un mensaje de error si la respuesta es nula
            return response.text ?? "No se generó ninguna respuesta."
        } catch {
            // Manejo de errores para evitar fallos en la ejecución
            print("Error al generar respuesta: \(error.localizedDescription)")
            return "Ocurrió un error al procesar la solicitud."
        }
    }
}
