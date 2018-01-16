//
//  ViewController.swift
//  SeeFood
//
//  Created by Kajal on 1/15/18.
//  Copyright © 2018 Kajal. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
     let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //info is dictionary type.and its key is string type but value is  unknown.so cast into UIImage type
        if let userPickedimage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = userPickedimage
            guard let ciimage = CIImage(image: userPickedimage) else {
                fatalError("could not convert ikmage to ciimage")
            }
        
        detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func detect(image: CIImage)
    {
       guard let model =  try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading coreMl model fail")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("model failed to process image")
            }
            if let firstResult = results.first
            {
                if firstResult.identifier.contains("gotdog")
                {
                    self.navigationItem.title = "HOT DOG"
                }
                else{
                    self.navigationItem.title = " NOT HOT DOG"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do{
           try handler.perform([request])
        }catch{
           print("error while handling image\(error)")
        }
    }
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
   
    present(imagePicker, animated: true, completion: nil)
    
    }
    
}

