import SwiftUI

internal struct SignUpView: View {
    @Environment(AuthViewModel.self) private var authViewModel

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var passwordsMatch = true
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Full Name", text: $name)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 20)
            
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
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .onChange(of: confirmPassword) { _, newValue in
                    passwordsMatch = password == newValue || newValue.isEmpty
                }
            
            if !passwordsMatch {
                Text("Passwords do not match")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: {
                let nameValue = name
                let emailValue = email
                let passwordValue = password
                Task {
                    await authViewModel.signUp(name: nameValue, email: emailValue, password: passwordValue)
                }
            }) {
                if authViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Create Account")
                        .fontWeight(.bold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .disabled(
                name.isEmpty || 
                email.isEmpty || 
                password.isEmpty || 
                confirmPassword.isEmpty || 
                !passwordsMatch ||
                authViewModel.isLoading
            )
        }
    }
}

#Preview {
    SignUpView()
        .environment(AuthViewModel(authService: AuthManager(networkService: MockNetworkService())))
}

// Mock for preview
private struct MockNetworkService: AuthNetworkService {
    func post<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U {
        throw AuthError.signInFailed
    }
}
