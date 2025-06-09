import SwiftUI

public struct AuthView: View {
    @State private var isSignIn = true
    @Environment(AuthViewModel.self) private var authViewModel
    
    public init() {}
    
    public var body: some View {
        @Bindable var authViewModel = authViewModel
        NavigationView {
            VStack {
                // Logo and app name
                VStack {
                    Image(systemName: "figure.run")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("FitJourney")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                }
                .padding(.top, 50)
                
                // Toggle between sign in and sign up
                Picker("", selection: $isSignIn) {
                    Text("Sign In").tag(true)
                    Text("Sign Up").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                if isSignIn {
                    SignInView()
                } else {
                    SignUpView()
                }
                
                Spacer()
            }
            #if os(iOS)
            .navigationBarHidden(true)
            #endif
            .alert(
                item: $authViewModel.error
            ) { error in
                Alert(title: Text("Error"),
                      message: Text(error.localizedDescription),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}


#Preview {
    AuthView()
        .environment(AuthViewModel(authService: AuthManager(networkService: MockNetworkService())))
}

// Mock for preview
private struct MockNetworkService: AuthNetworkService {
    func post<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U {
        throw AuthError.signInFailed
    }
}
