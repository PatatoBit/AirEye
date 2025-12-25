//
//  CameraManager.swift
//  AirEye
//
//  Created by Patato on 20/12/25.
//

import AVFoundation
import Combine
import SwiftUI
import Vision

class CameraManager: NSObject, ObservableObject {
  @Published var currentAQI: Int = 0
  @Published var confidence: String = "Calculating..."
  @Published var errorMessage: String?

  // Camera Session
  let session = AVCaptureSession()
  private let videoOutput = AVCaptureVideoDataOutput()
  private let photoOutput = AVCapturePhotoOutput()
  private let context = CIContext()

  // Vision Request
  private var visionRequest: VNCoreMLRequest?

  @Published var capturedImage: UIImage?
  @Published var capturedAQI: Int = 0

  override init() {
    super.init()
    setupVision()
    checkPermissions()
  }

  // 1. Setup Vision Model
  private func setupVision() {
    do {
      // Load your specific model class
      let config = MLModelConfiguration()
      let model = try AirQualityRegressor(configuration: config)
      let visionModel = try VNCoreMLModel(for: model.model)

      visionRequest = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
        self?.handlePrediction(request, error: error)
      }

      // Vision handles resizing to 224x224 automatically.
      // .centerCrop is good for sky/environment; .scaleFill distorts shapes.
      visionRequest?.imageCropAndScaleOption = .centerCrop

    } catch {
      self.errorMessage = "Model Load Error: \(error.localizedDescription)"
    }
  }

  // 2. Setup Camera
  private func checkPermissions() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      setupCamera()
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { granted in
        if granted { DispatchQueue.main.async { self.setupCamera() } }
      }
    default:
      self.errorMessage = "Camera access denied. Please enable in Settings."
    }
  }

  private func setupCamera() {
    session.beginConfiguration()
    session.sessionPreset = .vga640x480  // Lower res needed for ML, saves battery

    guard
      let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
      let input = try? AVCaptureDeviceInput(device: device)
    else {
      errorMessage = "No camera found."
      session.commitConfiguration()
      return
    }

    if session.canAddInput(input) { session.addInput(input) }

    if session.canAddOutput(videoOutput) {
      session.addOutput(videoOutput)
      // Drop frames if processing is too slow to keep up
      videoOutput.alwaysDiscardsLateVideoFrames = true
      videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera.queue"))
    }

    if session.canAddOutput(photoOutput) {
      session.addOutput(photoOutput)
    }

    session.commitConfiguration()

    DispatchQueue.global(qos: .userInitiated).async {
      self.session.startRunning()
    }
  }

  // 3. Handle Prediction Results
  private func handlePrediction(_ request: VNRequest, error: Error?) {
    guard let results = request.results as? [VNCoreMLFeatureValueObservation],
      let firstResult = results.first,
      let multiArray = firstResult.featureValue.multiArrayValue
    else { return }

    // Get the raw log output from the model
    let logValue = multiArray[0].doubleValue

    // Reverse your formula: AQI = (e^y - 1) / 9.0 * 300
    let LOG_ALPHA = 9.0
    let AQI_MAX = 300.0
    let aqi = ((exp(logValue) - 1.0) / LOG_ALPHA) * AQI_MAX

    DispatchQueue.main.async {
      self.currentAQI = Int(aqi)
      self.confidence = "Live"
    }
  }

  func capturePhoto() {
    capturedAQI = currentAQI
    let settings = AVCapturePhotoSettings()
    photoOutput.capturePhoto(with: settings, delegate: self)
  }
}

// 4. Feed Frames to Vision
extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate
{
  func captureOutput(
    _ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
  ) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
      let request = visionRequest
    else { return }

    // Rotate image if needed (default is landscape left)
    let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right)

    do {
      try handler.perform([request])
    } catch {
      print("Vision error: \(error)")
    }
  }

  func photoOutput(
    _ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?
  ) {
    if let error = error {
      print("Error capturing photo: \(error)")
      return
    }

    guard let data = photo.fileDataRepresentation(),
      let image = UIImage(data: data)
    else { return }

    DispatchQueue.main.async {
      self.capturedImage = image
    }
  }
}
