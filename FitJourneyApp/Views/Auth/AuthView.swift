import SwiftUI

struct AuthView: View {
    @State private var isSignIn = true
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
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
            .navigationBarHidden(true)
            .alert(item: Binding<AuthAlert?>(
                get: { authViewModel.errorMessage != nil ? AuthAlert(message: authViewModel.errorMessage!) : nil },
                set: { _ in authViewModel.errorMessage = nil }
            )) { alert in
                Alert(title: Text("Error"), message: Text(alert.message), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AuthAlert: Identifiable {
    var id: String { message }
    let message: String
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(AuthViewModel())
    }
}
