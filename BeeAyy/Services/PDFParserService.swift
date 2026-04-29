import Foundation
import PDFKit
import UIKit

struct PDFParserService {

	// call this after first download so that it can load from disk instead of refetching
	static func cachedOrFetch(sermon: Sermon) async throws -> PDFDocument {
		let cacheURL = FileManager.default
			.urls(for: .cachesDirectory, in: .userDomainMask)[0]
			.appendingPathComponent("sermon-\(sermon.id).pdf") // append with id as unique identifier
		
		if let data = try? Data(contentsOf: cacheURL),
			 let pdf = PDFDocument(data: data) {
				return pdf
		}
		
		let (data, _) = try await URLSession.shared.data(from: sermon.pdfURL)
		try? data.write(to: cacheURL)
		
		guard let pdf = PDFDocument(data: data) else { throw SermonError.invalidPDF }
		return pdf
	}
}
