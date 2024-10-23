//
//  ViewController.swift
//  FakeAI
//
//  Created by Sen Cai on 10/18/24.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    var firstRun = true
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        photoPicker.delegate = self
    }
    
    
    @IBAction func selectImage(_ sender: UIButton) {
        present(photoPicker, animated: true)
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
    }
    
}

extension ViewController {
    func updateImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    func updateResult(_ message: String) {
        DispatchQueue.main.async {
            self.resultLabel.text = message
        }
        
        if firstRun {
            DispatchQueue.main.async {
                self.firstRun = false
                self.resultLabel.superview?.isHidden = false
            }
        }
    }
    
    func userSelectedPhoto(_ photo: UIImage) {
        updateImage(photo)
        updateResult("Making predictions for the photo...")
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.classifyImage(photo)
        }
    }
}
