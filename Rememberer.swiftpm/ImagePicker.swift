import SwiftUI
import Foundation
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Binding var isPickerShowing: Bool
    private let completionHandler: ([String]?) -> Void
    
    init(selectedImage: Binding<UIImage?>, isPickerShowing: Binding<Bool>, completion: @escaping ([String]?) -> Void) {
        _selectedImage = selectedImage
        _isPickerShowing = isPickerShowing
        self.completionHandler = completion
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, completion: completionHandler)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        private let completionHandler: ([String]?) -> Void
        var parent: ImagePicker
        
        init(_ picker: ImagePicker, completion: @escaping ([String]?) -> Void) {
            self.parent = picker
            self.completionHandler = completion
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            print("image selected")
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                DispatchQueue.main.async { [self] in
                    self.parent.selectedImage = image
                    let recognizer = TextRecognizer(photoScan: image)
                    recognizer.recognizeText(withCompletionHandler: completionHandler)
                }
            }
            
            parent.isPickerShowing = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print("cancelled")
            parent.isPickerShowing = false
        }
    }
}
