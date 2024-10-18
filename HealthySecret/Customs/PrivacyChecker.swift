//
//  PrivacyCheckerDelegate.swift
//  HealthySecret
//
//  Created by 양승완 on 5/10/24.
//

import Foundation
import UIKit
import AVFoundation
import Photos

class PrivacyChecker {
    
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func showAlertGoToSetting(text: String) {
        let alertController = UIAlertController(
            title: "현재 \(text) 사용에 대한 접근 권한이 없습니다",
            message: "설정 > HealthySecret 탭에서 \(text) 접근 권한을 허용해주세요",
            preferredStyle: .alert
        )
        let cancelAlert = UIAlertAction(
            title: "취소",
            style: .cancel
        ) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        let goToSettingAlert = UIAlertAction(
            title: "설정",
            style: .default) { _ in
                guard
                    let settingURL = URL(string: UIApplication.openSettingsURLString),
                    UIApplication.shared.canOpenURL(settingURL)
                else { return }
                UIApplication.shared.open(settingURL, options: [:])
            }
        [cancelAlert, goToSettingAlert]
            .forEach(alertController.addAction(_:))
        DispatchQueue.main.async {
            self.viewController.present(alertController, animated: true) // must be used from main thread only
        }
    }
    
    public func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                print("카메라 권한 허용")
                DispatchQueue.main.async {
                    
                    self.presentCamera()
                    
                }
                
            } else {
                print("카메라 권한 거부")
                self.showAlertGoToSetting(text: "카메라")
            }
        })
    }
    public func requestAlbumPermission() {
        PHPhotoLibrary.requestAuthorization( { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    
                    self.presentAlbum()
                    
                }
            case .denied:
                self.showAlertGoToSetting(text: "앨범")
            case .restricted, .notDetermined:
                print("Album: 선택하지 않음")
            default:
                break
            }
        })
    }
    
    public func presentCamera() {
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = viewController as? any UIImagePickerControllerDelegate & UINavigationControllerDelegate
        vc.allowsEditing = true
        vc.cameraFlashMode = .on
        
        self.viewController.present(vc, animated: true, completion: nil)
    }
    
    public func presentAlbum() {
        
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = viewController as? any UIImagePickerControllerDelegate & UINavigationControllerDelegate
        vc.allowsEditing = true
        
        self.viewController.present(vc, animated: true, completion: nil)
    }
    
    
    
}
