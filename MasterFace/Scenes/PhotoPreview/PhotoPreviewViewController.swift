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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var scrollView: UIScrollView!
    private var contentImageView: UIImageView!
    private var viewModel = PhotoPreviewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        activityIndicator.startAnimating()
        if let cgimage = image.cgImage {
            let flippedImage = UIImage(cgImage: cgimage, scale: image.scale, orientation: .leftMirrored)
            
            imageView.image = flippedImage
        } else {
            imageView.image = image
        }
        viewModel.recognizeFaceOn(imageView.takeScreenshot(afterScreenUpdates: true), drawTo: faceView)

        activityIndicator.stopAnimating()

        DispatchQueue.main.async {
            self.showResultPhoto()
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PhotoPreviewViewController: UIScrollViewDelegate {

    private func showResultPhoto() {
        let imahe = self.view.takeScreenshot(afterScreenUpdates: true)
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.black
        scrollView.contentSize = imageView.bounds.size
        scrollView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
        contentImageView = UIImageView(frame: self.view.bounds)
        contentImageView.isUserInteractionEnabled = true
        scrollView.addSubview(contentImageView)
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 10.0
        scrollView.zoomScale = 1.0
        contentImageView.image = imahe
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.contentImageView
    }
}
