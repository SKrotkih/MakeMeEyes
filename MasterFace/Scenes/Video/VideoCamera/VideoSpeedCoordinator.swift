//
//  VideoSpeedCoordinator.swift
//  MasterFace
//
//  Created by Сергей Кротких on 29/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import Foundation

class VideoSpeedCoordinator  {

    enum VideoSpeedState {
        case undefined
        case fast
        case slow
    }

    private var currentState: VideoSpeedState = .undefined {
        didSet {
            switch currentState {
            case .slow:
                break
            case .fast:
                break
            case .undefined:
                break
            }
        }
    }
    
    var eyesIndex: Int = 0 {
        didSet {
            if eyesIndex == 0 {
                currentState = .fast
            } else {
                currentState = .slow
            }
        }
    }

    var maskIndex: Int = 0 {
        didSet {
            if eyesIndex > 0 {
                currentState = .fast
            }
        }
    }
    
}
