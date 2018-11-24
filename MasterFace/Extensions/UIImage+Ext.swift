//
//  UIView+Ext.swift
//  MasterFace
//
//  Created by Сергей Кротких on 06/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import UIKit

extension UIView {
    
    func takeScreenshot(afterScreenUpdates: Bool) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let screenshot = renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: afterScreenUpdates)
        }
        return screenshot
    }
}
