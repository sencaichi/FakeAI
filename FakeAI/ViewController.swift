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
    
    let config = MLModelConfiguration()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }
    
    func classifyImage(_ image: UIImage) {
        guard let model = try? AI_or_Human(configuration: .init()) else {
            fatalError("Failed to load model")
        }
        
        guard let pixelBuffer = image.toCVPixelBuffer() else {
            return
        }
        
        if let prediction = try? model.prediction(image: pixelBuffer) {
            resultLabel.text = "This image is \(prediction.classLabel)"
        }
    }
    
}
