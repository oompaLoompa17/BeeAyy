import GoogleSignInSwift
import SwiftUI

struct MainView: View {
	@Environment(AuthViewModel.self) var auth

	var body: some View {
		if auth.isSignedIn {
			AppTabsView()
		} else {
			LoginView()
		}
	}
}

#Preview {
	MainView()
}
