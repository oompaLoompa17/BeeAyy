import PDFKit

// MARK: Single source of truth for sermon data. Knows about the manifest, the cache, and the documents directory. Returns Sermon objects with their current local state ("downloaded" / "cached" / "remote-only").
struct SermonRepository {
	let cache: PDFCache
	
	func loadPDF(for sermon: Sermon) async throws -> PDFDocument {
		// Check permanent storage first (user downloaded it)
		if let data = await cache.load(sermonID: sermon.id, location: .permanent),
			 let pdf = PDFDocument(data: data) {
			return pdf
		}
		
		// Then temporary cache
		if let data = await cache.load(sermonID: sermon.id, location: .temporary),
			 let pdf = PDFDocument(data: data) {
			return pdf
		}
		
		// Fetch from network
		let (data, response) = try await URLSession.shared.data(from: sermon.pdfURL)
		guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
			throw SermonError.downloadFailed
		}
		guard let pdf = PDFDocument(data: data) else {
			throw SermonError.invalidPDF
		}
		
		try? await cache.save(data, sermonID: sermon.id, location: .temporary)
		return pdf
	}
	
	func download(_ sermon: Sermon) async throws {
		// Make sure it's in the cache, then promote
		_ = try await loadPDF(for: sermon)
		try await cache.promoteToPermanent(sermonID: sermon.id)
	}
	
	func isDownloaded(_ sermon: Sermon) async -> Bool {
		await cache.exists(sermonID: sermon.id, location: .permanent)
	}
}
