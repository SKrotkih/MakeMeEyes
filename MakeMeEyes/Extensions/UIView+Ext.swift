//
//  UIView+Ext.swift
//  MakeMeEyes
//
//  Created by Sergey Krotkih on 06/11/2018.
//  Copyright © 2018 Sergey Krotkih. All rights reserved.
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
