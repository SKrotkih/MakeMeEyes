//
//  ViewController.swift
//  MakeMeEyes
//
//  Created by Sergey Krotkih on 05/11/2018.
//  Copyright © 2018 Sergey Krotkih. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var lenaImageView: UIImageView!
    @IBOutlet weak var mandrilImageView: UIImageView!
    
    // MARK: - Variables
    var image: UIImage!
    
    //lazy var utils: CppUtils = CppUtils()
    
    // MARK: - Life
    
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
    public override func loadView() {
        super.loadView()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(OpenCVWrapper.openCVVersionString())")
        
        // Test of the CPP channel
        // lenaImageView.image = OpenCVWrapper.callCPP(lenaImageView.image!);
    }
    
    
    @IBAction func tapOnLenaPhoto(_ sender: Any) {
        if let lenaImage = lenaImageView.image {
            image = lenaImage
            performSegue(withIdentifier: "showImageSegue", sender: self)
        }
    }
    
    @IBAction func tapOnMadrillPhoto(_ sender: Any) {
        if let madrilImage = mandrilImageView.image {
            image = madrilImage
            performSegue(withIdentifier: "showImageSegue", sender: self)
        }
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {action in
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            picker.sourceType = .photoLibrary
            // on iPad we are required to present this as a popover
            if UIDevice.current.userInterfaceIdiom == .pad {
                picker.modalPresentationStyle = .popover
                picker.popoverPresentationController?.sourceView = self.view
                picker.popoverPresentationController?.sourceRect = self.takePhotoButton.frame
            }
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // on iPad this is a popover
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = takePhotoButton.frame
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        image = selectedImage
        performSegue(withIdentifier: "showImageSegue", sender: self)

        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageSegue" {
            if let imageViewController = segue.destination as? ImageViewController {
                imageViewController.image = self.image
            }
        }
    }
    
    @IBAction func exit(unwindSegue: UIStoryboardSegue) {
        image = nil
    }
}
