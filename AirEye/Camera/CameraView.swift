//
//  CameraView.swift
//  AirEye
//
//  Created by Patato on 20/12/25.
//

import SwiftUI
import AVFoundation

// 1. Create a custom UIView that manages the layer resizing automatically
class PreviewView: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}

// 2. The SwiftUI Wrapper
struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.backgroundColor = .black // Visual feedback if camera is loading
        
        // Connect the session to the layer
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        view.videoPreviewLayer.connection?.videoOrientation = .portrait // Force portrait for phone apps
        
        return view
    }
    
    func updateUIView(_ uiView: PreviewView, context: Context) {
        // No manual frame setting needed; the layer resizing is handled by the view architecture
    }
}
