import Foundation
import Vision
import VisionKit
import SwiftUI

final class TextRecognizer {
    let cameraScan: VNDocumentCameraScan?
    let photoScan: UIImage?
    
    init(cameraScan: VNDocumentCameraScan) {
        self.cameraScan = cameraScan
        self.photoScan = nil
    }
    
    init(photoScan: UIImage) {
        self.cameraScan = nil
        self.photoScan = photoScan
    }
    
    private let queue = DispatchQueue(label: "scan-codes", qos: .default, attributes: [], autoreleaseFrequency: .workItem)
    
    func recognizeText(withCompletionHandler completionHandler: @escaping ([String]) -> Void) {
        queue.async {
            let images: [CGImage?]
            if let cameraScan = self.cameraScan {
                images = (0..<cameraScan.pageCount).compactMap {
                    cameraScan.imageOfPage(at: $0).cgImage
                }
            } else if let photoScan = self.photoScan {
                // Assuming photoScan is a single page UIImage
                images = [photoScan.cgImage]
            } else {
                images = []
            }
            
            let imagesAndRequests = images.map { (image: $0, request: VNRecognizeTextRequest()) }
            let textPerPage = imagesAndRequests.map { image, request -> String in
                guard let image = image else { return "" }
                
                let handler = VNImageRequestHandler(cgImage: image, options: [:])
                do {
                    try handler.perform([request])
                    guard let observations = request.results as? [VNRecognizedTextObservation] else { return "" }
                    return observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                } catch {
                    print(error)
                    return ""
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(textPerPage)
            }
        }
    }
}
