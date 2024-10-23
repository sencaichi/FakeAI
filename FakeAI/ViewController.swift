//
//  ViewController.swift
//  FakeAI
//
//  Created by Sen Cai on 10/18/24.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    // let config = MLModelConfiguration()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }
    
    
    @IBAction func selectImage(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                imageView.image = pickedImage
                classifyImage(pickedImage)
            }
            dismiss(animated: true, completion: nil)
        }
    
    func classifyImage(_ image: UIImage) {
        // create a Vision instance using the image classifier's model instance
        guard let model = try? VNCoreMLModel(for: AI_or_Human(configuration: MLModelConfiguration()).model) else {
            fatalError("Failed to load model.")
        }
                
        if let prediction = try? model.prediction(image: pixelBuffer) {
            resultLabel.text = "This image is \(prediction.target)"
        }
    }
    
}
