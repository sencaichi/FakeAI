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
    
    let imagePredictor = ImagePredictor()
    
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

extension ViewController {
    func classifyImage(_ image: UIImage) {
        // create a Vision instance using the image classifier's model instance
        do {
            try self.imagePredictor.makePredictions(for: image, completionHandler: imagePredictionHandler)
        } catch {
            print("Vision was unable to make a prediction...")
        }
    }
    
    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
        guard let predictions = predictions else {
            updateResult("No predictions. (Check console log.)")
            return
        }

        let formattedPredictions = formatPredictions(predictions)

        let predictionString = formattedPredictions.joined(separator: "\n")
        updatePredictionLabel(predictionString)
    }
    
    private func formatPredictions(_ predictions: [ImagePredictor.Prediction]) -> [String] {
        // Vision sorts the classifications in descending confidence order.
        let topPredictions: [String] = predictions.prefix(predictionsToShow).map { prediction in
            var name = prediction.target

            // For classifications with more than one name, keep the one before the first comma.
            if let firstComma = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstComma))
            }

            return "\(name) - \(prediction.confidencePercentage)%"
        }

        return topPredictions
    }
}
