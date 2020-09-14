//
//  ViewController.swift
//  TechtaGram
//
//  Created by 伊藤　陽香 on 2020/09/13.
//  Copyright © 2020 伊藤　陽香. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet var cameraImageView: UIImageView!
    
    //画像加工するための元となる画像
    var originalImage: UIImage!
    
    //画像加工するフィルターの宣言
    var filter: CIFilter!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func takePhoto() {
        
        //カメラが使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            //カメラを起動
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }else {
            //カメラを使えない時は、エラーがコンソールにでます
            print("error")
        }
        
    }
    
    @IBAction func savePhoto() {
        //編集した画像を保存するためのメソッド
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
        
        
    }
    
    @IBAction func colorFilter() {
        
        let filterImage: CIImage = CIImage(image: originalImage)!
        
        //フィルターの設定
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        //彩度の調整
        filter.setValue(1.0, forKey: "inputSaturation")
        //明度の調整
        filter.setValue(0.5, forKey: "inputBrightness")
        //コントラストの調整
        filter.setValue(2.5, forKey: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
        
        
        
    }
    
    @IBAction func openAlbum() {
        
        //カメラロールを使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            //カメラロールを選択して、画像を表示するまでの一連の流れ
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func snsPhoto() {
        
        //投稿する時に一緒に投稿するコメント
        let shareText = "写真を撮ったよ！"
        
        //投稿する画像の選択
        let shareImage = cameraImageView.image!
        
        //投稿するコメントと画像の準備
        let activityItems: [Any] = [shareText, shareImage]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        let excludedActivityTypes = [UIActivity.ActivityType.postToWeibo, .saveToCameraRoll,.print]
        
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        present(activityViewController, animated: true, completion: nil)
        
    }

    //カメラ、カメラロールをう使った時に、選択した画像をアプリ内に表示するためのメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        cameraImageView.image = info[.editedImage] as? UIImage
        
        originalImage = cameraImageView.image
        
        dismiss(animated: true, completion: nil)
    }

}

