import SwiftUI
import GoogleSignIn

@main
struct BeeAyyApp: App {
	@State private var auth = AuthViewModel.shared
	
	var body: some Scene {
		WindowGroup {
			MainView()
				.environment(auth)
				.onOpenURL { url in
					GIDSignIn.sharedInstance.handle(url)
				}
				.onAppear {
					auth.checkUser()
				}
		}
	}
}
