//
//  MJBottomSheet.swift
//  AnyTrekForklift
//
//  Created by 郭明健 on 2023/3/9.
//

import UIKit

class MJBottomSheet {
    /// 底部弹窗：拍照、相册、取消
    static func show(atViewController: UIViewController,
                     camera: String = "Camera",
                     photoAlbum: String = "Photo album",
                     cancel: String = "Cancel",
                     cameraBlock: (()->Void)? = nil,
                     photoAlbumBlock: (()->Void)? = nil,
                     cancelBlock: (()->Void)? = nil) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraSheet = UIAlertAction(title: camera, style: .default) {
            action in
            // 相机
            if cameraBlock != nil {
                cameraBlock!()
            }
        }
        let photoAlbumSheet = UIAlertAction(title: photoAlbum, style: .default) {
            action in
            // 相册
            if photoAlbumBlock != nil {
                photoAlbumBlock!()
            }
        }
        let cancelSheet = UIAlertAction(title: cancel, style: .cancel) {
            action in
            if cancelBlock != nil {
                cancelBlock!()
            }
        }
        alert.addAction(cameraSheet)
        alert.addAction(photoAlbumSheet)
        alert.addAction(cancelSheet)
        //
        DispatchQueue.main.async {
            atViewController.present(alert, animated: true, completion: nil)
        }
    }
}
