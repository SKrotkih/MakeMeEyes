//
//  VideoSpeedStrategy.swift
//  MasterFace
//
//  Created by Сергей Кротких on 29/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import Foundation

final class VideoSpeedStrategy  {

    enum VideoSpeedState {
        case undefined
        case fast
        case slow;
        
        static func defaultState() -> VideoSpeedState {
            // It is the default value of the start view
            return .fast
        }
    }

    private var videoCameraWrapper: VideoCameraProtocol?
    private var eyesVideoCameraWrapper: EyesCvVideoCameraWrapper?
    private var faceVideoCameraWrapper: FaceCvVideoCameraWrapper?

    private var videoParentView: UIImageView
    private var drawingView: EyesDrawingView
    private var sceneInteractor: SceneInteractor

    init(videoParentView: UIImageView,
               drawingView: EyesDrawingView,
               sceneInteractor: SceneInteractor
        ) {
        self.sceneInteractor = sceneInteractor
        self.drawingView = drawingView
        self.videoParentView = videoParentView
    }
    
    var currentState: VideoSpeedState = .undefined {
        didSet {
            if oldValue == currentState {
                return
            }
            switch currentState {
            case .slow:
                stopFastVideo()
                startSloWVideo()
            case .fast:
                stopSlowVideo()
                startFastVideo()
            case .undefined:
                break
            }
        }
    }
    
    func setPupilPercent(_ value: Double) {
        if currentState == .slow {
            eyesVideoCameraWrapper!.setPupilPercent(value)
        }
    }
    
    func setLenseColorAlpha(_ value: Double) {
        if currentState == .slow {
            eyesVideoCameraWrapper!.setLenseColorAlpha(value)
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
        videoCameraWrapper?.startCamera()
    }
    
    func videoIsInitialized() -> Bool {
        return currentState == .slow || currentState == .fast
    }
    
    func showBox() {
        if currentState == .slow {
            eyesVideoCameraWrapper!.showBox()
        }
    }

    func showMask() {
        if currentState == .fast {
            sceneInteractor.showMask()
        }
    }
}

// MARK: - Fast/Slow video speed coordinator

extension VideoSpeedStrategy {
    
    // We use the slow video for eyes presentation
    private func startSloWVideo() {
        DispatchQueue.main.async { [unowned self] in
            self.eyesVideoCameraWrapper = EyesCvVideoCameraWrapper(videoParentView: self.videoParentView,
                                                                   drawing: self.drawingView)
            self.videoCameraWrapper = self.eyesVideoCameraWrapper
            self.eyesVideoCameraWrapper!.startCamera()
            NotificationCenter.default.post(name: .didUpdateVideoSize, object: nil)
        }
    }
    
    private func stopSlowVideo() {
        DispatchQueue.main.async { [unowned self] in
            self.eyesVideoCameraWrapper?.stopCamera()
            self.eyesVideoCameraWrapper = nil
        }
    }

    // We use the slow video for masks presentation
    private func startFastVideo() {
        DispatchQueue.main.async { [unowned self] in
            self.faceVideoCameraWrapper = FaceCvVideoCameraWrapper(videoParentView: self.videoParentView,
                                                                   drawing: self.drawingView,
                                                                   sceneInteractor: self.sceneInteractor)
            self.videoCameraWrapper = self.faceVideoCameraWrapper
            self.faceVideoCameraWrapper!.startCamera()
            NotificationCenter.default.post(name: .didUpdateVideoSize, object: nil)
        }
    }
    
    private func stopFastVideo() {
        DispatchQueue.main.async { [unowned self] in
            self.sceneInteractor.hideMask()
            self.faceVideoCameraWrapper?.stopCamera()
            self.faceVideoCameraWrapper = nil
        }
    }
}
