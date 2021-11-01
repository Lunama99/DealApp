//
//  ScanViewController.swift
//  Vera
//
//  Created by Macbook on 01/07/2021.
//

import AVFoundation
import UIKit

class ScanViewController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var squareView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var closeBtn: BaseButton!
    
    private let voucherInvoiceRepo = VoucherInvoiceRepository()
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var callBack: ((String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        view.bringSubviewToFront(backgroundImageView)
        view.bringSubviewToFront(closeBtn)
        view.bringSubviewToFront(squareView)
        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue, stringValue.trimmingCharacters(in: .whitespaces) != "" else { return }
            guard let barCodeObject = previewLayer?.transformedMetadataObject(for: metadataObject) else { return }
            guard squareView.frame.contains(barCodeObject.bounds) else {
                return
            }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }

    func found(code: String) {
        captureSession.stopRunning()
        updateVoucherStatus(code: code)
    }
    
    func updateVoucherStatus(code: String) {
        stateView = .loading
        voucherInvoiceRepo.updateStatusVoucher(code: code) { [weak self] result in
            self?.stateView = .ready
            switch result {
            case .success(let response):
                do {
                    let model = try response.map(DefaultResponse.self)
                        let alert = UIAlertController(title: "", message: model.message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { action in
                            self?.captureSession.startRunning()
                        })
                        self?.present(alert, animated: true, completion: nil)
                } catch {
                    print("update voucher invoices failed")
                }
            case .failure(_): break
            }
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func dismissActionButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
