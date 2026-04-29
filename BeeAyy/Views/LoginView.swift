import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
	@Environment(AuthViewModel.self) var auth
	
	var body: some View {
		VStack(spacing: 24) {
			Image(systemName: "globe")
				.imageScale(.large)
				.foregroundStyle(.tint)
			Text("Welcome to BeeAyy")
				.font(.title)
			GoogleSignInButton(action: auth.signIn)
		}
		.padding()
	}
}
