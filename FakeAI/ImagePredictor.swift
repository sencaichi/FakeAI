//
//  ImagePredictor.swift
//  FakeAI
//
//  Created by Sen Cai on 10/23/24.
//

import Vision
import UIKit

class ImagePredictor {
    static func createImageClassifier() -> VNCoreMLModel {
        let defaultConfig = MLModelConfiguration()
        
        let imageClassifierWrapper = try? AI_or_Human(configuration: defaultConfig)
        
        guard let imageClassifier = imageClassifierWrapper else {
            fatalError("App failed to create an image classifier model instance.")
        }
        
        let imageClassifierModel = imageClassifier.model
        
        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierModel) else {
            fatalError("App failed to create a `VNCoreMLModel` instance.")
        }
        
        return imageClassifierVisionModel
    }
    
    // a common image classifier instance that all Image Predictor instances use to generate predictions
    private static let imageClassifier = createImageClassifier()
}