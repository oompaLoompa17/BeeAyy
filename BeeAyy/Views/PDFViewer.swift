import PDFKit
import SwiftUI

struct PDFViewer: UIViewRepresentable {
	let document: PDFDocument
	
	func makeUIView(context: Context) -> PDFView {
		let view = PDFView()
		view.document = document
		view.autoScales = true
		view.displayMode = .singlePageContinuous
		view.displayDirection = .vertical
		view.usePageViewController(false)
		view.backgroundColor = .systemBackground
		return view
	}
	
	// prevents unnecessary reloads when SwiftUI rerenders the view but doc hasn't changed
	func updateUIView(_ uiView: PDFView, context: Context) {
		if uiView.document !== document { uiView.document = document }
	}
}
