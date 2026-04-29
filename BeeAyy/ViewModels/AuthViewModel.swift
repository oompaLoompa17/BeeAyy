import GoogleSignIn
import SwiftUI

@Observable
final class AuthViewModel {
	var isSignedIn = false
	var user: GIDGoogleUser?  // The Google user object — contains profile info, tokens, etc.

	static let shared = AuthViewModel()

	/// Checks if the user has previously signed in (e.g. from a past app session).
	/// Google's SDK stores sign-in tokens in the keychain, so this restores that session
	/// without showing the sign-in UI again.
	func checkUser() {
		// restorePreviousSignIn tries to silently restore a cached Google session.
		// The completion handler gives us either a valid user or an error.
		GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
			// restorePreviousSignIn calls back on a background thread,
			// so we use DispatchQueue.main to safely update our @Published properties.
			DispatchQueue.main.async {
				self.user = user
				self.isSignedIn = user != nil
			}
		}
	}

	/// Presents the Google Sign-In sheet and handles the result.
	func signIn() {
		// Google's sign-in UI needs a presenting view controller to show its web-based login sheet.
		// This grabs the root view controller from the app's first active window.
		guard let rootVC = UIApplication.shared.connectedScenes
			.compactMap({ $0 as? UIWindowScene })  // Filter for window scenes only
			.first?.windows.first?.rootViewController else { return }

		// signIn(withPresenting:) shows the Google Sign-In sheet (a web view overlay).
		// When the user completes or cancels, the completion handler fires.
		GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
			// result contains .user (the signed-in Google user) on success.
			// error is non-nil if the user cancelled or something went wrong.
			DispatchQueue.main.async {
				self.user = result?.user
				self.isSignedIn = result?.user != nil
			}
		}
	}

	/// Signs out the current user. This clears the cached session immediately.
	func signOut() {
		GIDSignIn.sharedInstance.signOut()  // Tells Google SDK to clear its stored tokens
		user = nil
		isSignedIn = false
	}
	
//	func checkGDScope() {
//		let grantedScopes = user?.grantedScopes
//		if grantedScopes == nil || !grantedScopes!.contains(Endpoints.googleDriveScope) {
//			requestGDScope()
//		}
//	}
	
//	func requestGDScope() {
//		let additionalScope = [Endpoints.googleDriveScope]
//		user?.addScopes(additionalScope, presenting: self) { signInResult, error in
//			guard error == nil else { return }
//			guard let signInResult = signInResult else { return }
//			
//			// Check if the user granted access to the scopes requested
//		}
//	}
}
