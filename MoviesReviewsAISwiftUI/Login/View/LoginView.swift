//
//  LoginView.swift
//  MoviesReviewsAISwiftUI
//
//  Created by Kevinho Morales on 23/4/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "brain.head.profile")
                    .resizable()
                    .frame(width: 120, height: 130)
                    .foregroundColor(.primary)

                Text("Movies Reviews AI")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Discover AI-generated reviews of movies")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Spacer()

            VStack(spacing: 16) {
                Button {
                    viewModel.register()
                } label: {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).stroke())
                }
                Button {
                    viewModel.login()
                } label: {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).stroke())
                }

            }
            .padding(.horizontal, 40)

            Spacer()
        }
    }
}

#Preview {
    LoginView()
}
