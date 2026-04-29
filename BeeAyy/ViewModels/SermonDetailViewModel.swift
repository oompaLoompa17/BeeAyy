import SwiftUI
import PDFKit

@MainActor
@Observable
final class SermonDetailViewModel {
	let sermon: Sermon
	var pdf: PDFDocument?
	var loadError: Error?
	var isLoading = false
	var isDownloaded = false
	
	private let repository: SermonRepository
	
	init(sermon: Sermon, repository: SermonRepository) {
		self.sermon = sermon
		self.repository = repository
	}
	
	func load() async {
		isLoading = true
		defer { isLoading = false }
		
		do {
			pdf = try await repository.loadPDF(for: sermon)
			isDownloaded = await repository.isDownloaded(sermon)
		} catch {
			loadError = error
		}
	}
	
	func download() async {
		do {
			try await repository.download(sermon)
			isDownloaded = true
		} catch {
			loadError = error
		}
	}
}

