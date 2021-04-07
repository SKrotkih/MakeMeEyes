//
//  UIImage+Ext.swift
//  MakeMeEyes
//
//  Created by Sergey Krotkih on 06/11/2018.
//  Copyright © 2018 Sergey Krotkih. All rights reserved.
//

import UIKit

extension UIImage {
    
    func crop(area: CGRect) -> UIImage? {
        guard let imageRef = self.cgImage?.cropping(to: area) else {
            return nil
        }
        return UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
    }
    
    
    
}
