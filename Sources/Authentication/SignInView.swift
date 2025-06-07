import SwiftUI

internal struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @Environment(AuthViewModel.self) private var authViewModel

    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                #if os(iOS)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                #endif
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 20)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 20)
            
            Button(action: {
                let emailValue = email
                let passwordValue = password
                Task {
                    await authViewModel.signIn(email: emailValue, password: passwordValue)
                }
            }) {
                if authViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Sign In")
                        .fontWeight(.bold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)
            
            Button("Forgot Password?") {
                // Handle forgot password
            }
            .foregroundColor(.blue)
        }
    }
}

#Preview {
    SignInView()
        .environment(AuthViewModel(authService: AuthManager(networkService: MockNetworkService())))
}

// Mock for preview
private struct MockNetworkService: AuthNetworkService {
    func post<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U {
        throw AuthError.signInFailed
    }
}
