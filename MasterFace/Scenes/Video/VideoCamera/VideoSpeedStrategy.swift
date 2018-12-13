//
//  VideoSpeedStrategy.swift
//  MasterFace
//
//  Created by Сергей Кротких on 29/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import Foundation

class VideoSpeedStrategy  {

    enum VideoSpeedState {
        case undefined
        case fast
        case slow
    }

    private var eyesVideoCameraWrapper: EyesCvVideoCameraWrapper!
    private var faceVideoCameraWrapper: FaceCvVideoCameraWrapper!
    private var sceneInteractor: SceneInteractor!
    
    required init(videoParentView: UIImageView,
               drawingView: EyesDrawingView,
               sceneInteractor: SceneInteractor
        ) {
        self.sceneInteractor = sceneInteractor
        self.eyesVideoCameraWrapper = EyesCvVideoCameraWrapper(videoParentView: videoParentView,
                                                               drawing: drawingView);
        self.faceVideoCameraWrapper = FaceCvVideoCameraWrapper(videoParentView: videoParentView,
                                                               drawing: drawingView,
                                                               sceneInteractor: sceneInteractor);
    }
    
    private var currentState: VideoSpeedState = .undefined {
        didSet {
            switch currentState {
            case .slow:
                setUpSlowSpeed()
            case .fast:
                setUpFastSpeed()
            case .undefined:
                break
            }
        }
    }
    
    var eyesIndex: Int = 0 {
        didSet {
            switch eyesIndex {
            case 0:
                currentState = .fast
            case 1...:
                currentState = .slow
            default:
                break
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

// MARK: - Protocol methods

extension VideoSpeedStrategy {
    
    var videoSize: CGSize {
        let camWidth = eyesVideoCameraWrapper.camWidth();
        let camHeight = eyesVideoCameraWrapper.camHeight();
        return CGSize(width: CGFloat(camWidth), height: CGFloat(camHeight))
    }
    
    func stopCamera() {
        eyesVideoCameraWrapper.stopCamera()
    }
    
    func startCamera() {
        eyesVideoCameraWrapper.startCamera()
    }
    
    func showBox() {
        eyesVideoCameraWrapper.showBox()
    }
    
    func setPupilPercent(_ value: Double) {
        eyesVideoCameraWrapper.setPupilPercent(value)
    }
    
    func setLenseColorAlpha(_ value: Double) {
        eyesVideoCameraWrapper.setLenseColorAlpha(value)
    }
    
    func addScene() {
        sceneInteractor.addScene()
    }
}

// MARK: - Private methods

extension VideoSpeedStrategy {
    
    private func setUpSlowSpeed() {
        
    }
    
    private func setUpFastSpeed() {
        
    }
}
