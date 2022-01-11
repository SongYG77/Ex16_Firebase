//
//  UploadViewController.swift
//  Ex16_Firebase
//
//  Created by 송윤근 on 2022/01/11.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadViewController: UIViewController {
    
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var Textview: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func onBtnUpload(_ sender: UIButton) {
        uploadImage()
    }
    
    func uploadImage() {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let data = imageview.image!.pngData()
        
        //타임 스탬프를 이용하여 유니크한 파일 이름을 얻기 위해.
        
        let timestemp = Int(NSDate.timeIntervalSinceReferenceDate*1000)
        let imageFirstname = "idol" + String(timestemp) + ".png"
        
        let serverImageRef = storageRef.child(imageFirstname)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        let uploadTask = serverImageRef.putData(data!, metadata: metadata){
            (metadata, error) in
            guard metadata != nil else {
                print("업로드 실패")
                self.Textview.text.append("\n업로드 실패")
                return
            }
            print("업로드 성공함")
            self.Textview.text.append("\n업로드 성공")
            
            serverImageRef.downloadURL() {
                (url, error) in
                
                guard url != nil else {
                    
                    return
                }
                
                self.Textview.text.append("\n\(String(describing: url?.absoluteURL))")
            }
        }
        
    }

}
