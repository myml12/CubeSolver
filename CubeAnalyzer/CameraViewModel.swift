import SwiftUI
import AVFoundation

struct CameraPreview: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
        var captureSession: AVCaptureSession?
        var photoOutput = AVCapturePhotoOutput()
        var previewLayer: AVCaptureVideoPreviewLayer?
        var onImageCaptured: ((UIImage) -> Void)?

        override func viewDidLoad() {
            super.viewDidLoad()
            setupCamera()

            // Notificationを監視して、ContentViewからのcapturePhoto()アクションを受け取る
            NotificationCenter.default.addObserver(self, selector: #selector(capturePhoto), name: NSNotification.Name("CapturePhoto"), object: nil)
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            previewLayer?.frame = view.layer.bounds // プレビューのフレームを更新
        }

        func setupCamera() {
            let session = AVCaptureSession()
            guard let camera = AVCaptureDevice.default(for: .video) else { return }

            do {
                let input = try AVCaptureDeviceInput(device: camera)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
            } catch {
                print("カメラの初期化に失敗しました: \(error)")
            }

            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
            }

            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill // アスペクト比を維持
            self.previewLayer = previewLayer
            view.layer.addSublayer(previewLayer)
            
            self.captureSession = session
            
            // メインスレッドでstartRunningを呼び出す
            self.captureSession?.startRunning()
            do {
                try camera.lockForConfiguration()
                // ズームレベルの調節
                //iPhone16 Proで撮影しやすいようにセット
                // iPhone15では1.5でちょうどよかった
                camera.videoZoomFactor = 2.2
                camera.unlockForConfiguration()
            } catch {
                print("Failed to lock configuration: \(error)")
            }
            
        }
        
        // 写真撮影処理
        @objc func capturePhoto() {
            let settings = AVCapturePhotoSettings()
            photoOutput.capturePhoto(with: settings, delegate: self)
        }
        
        // キャプチャした写真をUIImageに変換してContentViewに返す
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            guard let imageData = photo.fileDataRepresentation(),
                  let capturedImage = UIImage(data: imageData) else {
                return
            }
            
            onImageCaptured?(capturedImage)
        }

    }

    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraViewController = CameraViewController()
        cameraViewController.onImageCaptured = { capturedImage in
            context.coordinator.imageCaptured(capturedImage)
        }
        return cameraViewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: CameraPreview

        init(_ parent: CameraPreview) {
            self.parent = parent
        }

        func imageCaptured(_ image: UIImage) {
            parent.image = image
        }
    }
}
