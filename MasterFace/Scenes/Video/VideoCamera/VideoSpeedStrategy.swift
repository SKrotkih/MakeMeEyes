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
        case slow;
        
        static func defaultState() -> VideoSpeedState {
            return .slow
        }
    }

    private var videoCameraWrapper: VideoCameraProtocol?
    private var eyesVideoCameraWrapper: EyesCvVideoCameraWrapper?
    private var faceVideoCameraWrapper: FaceCvVideoCameraWrapper?

    private var videoParentView: UIImageView!
    private var drawingView: EyesDrawingView!
    private var sceneInteractor: SceneInteractor!

    required init(videoParentView: UIImageView,
               drawingView: EyesDrawingView,
               sceneInteractor: SceneInteractor
        ) {
        self.sceneInteractor = sceneInteractor
        self.drawingView = drawingView
        self.videoParentView = videoParentView
    }
    
    private var currentState: VideoSpeedState = .undefined {
        didSet {
            if oldValue == currentState {
                return
            }
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
        if let camWidth = videoCameraWrapper?.camWidth(),
            let camHeight = videoCameraWrapper?.camHeight() {
            return CGSize(width: CGFloat(camWidth), height: CGFloat(camHeight))
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func stopCamera() {
        videoCameraWrapper?.stopCamera()
    }
    
    func startCamera() {
        if let videoCameraWrapper = self.videoCameraWrapper {
            videoCameraWrapper.startCamera()
        } else {
            currentState = VideoSpeedState.defaultState()
        }
    }
    
    func showBox() {
        if let eyesVideoCameraWrapper = eyesVideoCameraWrapper {
            eyesVideoCameraWrapper.showBox()
        }
    }
    
    func setPupilPercent(_ value: Double) {
        if let eyesVideoCameraWrapper = eyesVideoCameraWrapper {
            eyesVideoCameraWrapper.setPupilPercent(value)
        }
    }
    
    func setLenseColorAlpha(_ value: Double) {
        if let eyesVideoCameraWrapper = eyesVideoCameraWrapper {
            eyesVideoCameraWrapper.setLenseColorAlpha(value)
        }
    }
    
    func addScene() {
        sceneInteractor.addScene()
    }
}

// MARK: - Private methods

extension VideoSpeedStrategy {
    
    private func setUpSlowSpeed() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.faceVideoCameraWrapper = nil
            self.eyesVideoCameraWrapper = EyesCvVideoCameraWrapper(videoParentView: self.videoParentView,
                                                                   drawing: self.drawingView)
            self.videoCameraWrapper = self.eyesVideoCameraWrapper
            self.eyesVideoCameraWrapper!.startCamera()
        }
    }
    
    private func setUpFastSpeed() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.eyesVideoCameraWrapper = nil
            self.faceVideoCameraWrapper = FaceCvVideoCameraWrapper(videoParentView: self.videoParentView,
                                                                   drawing: self.drawingView,
                                                                   sceneInteractor: self.sceneInteractor)
            self.videoCameraWrapper = self.faceVideoCameraWrapper
            self.faceVideoCameraWrapper!.startCamera()
        }
    }
}
