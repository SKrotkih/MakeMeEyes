//
//  PhotoPreviewViewController.swift
//  MakeMeEyes
//
//  Created by Sergey Krotkih on 22/11/2018.
//  Copyright © 2018 Sergey Krotkih. All rights reserved.
//

import UIKit

// Take a photo from library or from camera and put
// content like eyes or mask on the photo

class PhotoPreviewViewController: UIViewController {

    var image: UIImage!
    var resultImage: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var faceView: EyesDrawingView!
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
        UIImageWriteToSavedPhotosAlbum(resultImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Saved!", message: "Image saved successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true)
        }
    }
}

extension PhotoPreviewViewController: UIScrollViewDelegate {

    private func showResultPhoto() {
        resultImage = self.view.takeScreenshot(afterScreenUpdates: true)
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
        contentImageView.image = resultImage
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.contentImageView
    }
}
