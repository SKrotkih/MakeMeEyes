//
//  PhotoPreviewViewController.swift
//  MasterFace
//
//  Created by Сергей Кротких on 22/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import UIKit

class PhotoPreviewViewController: UIViewController {

    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var faceView: FaceView!
    
    private var viewModel = PhotoPreviewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        imageView.image = image
        
        let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size)
        let screenshot = renderer.image { ctx in
            imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
        }
        
        viewModel.recognizeFaceOn(screenshot, drawTo: faceView)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        

        self.navigationController?.popViewController(animated: true)
    }
}
