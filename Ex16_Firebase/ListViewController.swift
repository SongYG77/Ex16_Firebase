//
//  ListViewController.swift
//  Ex16_Firebase
//
//  Created by 송윤근 on 2022/01/10.
//

import UIKit
import Firebase
import FirebaseFirestore

class ListViewController: UIViewController {
    
    
    @IBOutlet weak var Textview: UITextView!
    
    struct Idoldata {
        var name : String = ""
        var image : String = ""
        
        //firebase에서 db에 들어가는 데이터
        //클래스와 구조체가 들어갈 수 없다.
        //1. 넘버 타입을 바로 넣을수 있다
        //2. 스트링 타입을 바로 넣을수 있다.
        //3. Array
        //4. Dictionary
        //즉 구조체가 바로 들어가려면 dictionary 타입으로 바꿔줘야 함.
        
        func getDic() -> [String : String] {
            let dict = [
                "name" : self.name,
                "image" : self.image
            ]
            
            return dict
        }
    }
    
    var idolArr : Array<Idoldata> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    @IBAction func onBtnAdd(_ sender: UIButton) {
        
        addListData()
    }
    
    @IBAction func onBtnRead(_ sender: UIButton) {
        readListData()
        
    }
    
    func addListData() {
        var idol = Idoldata()
        idol.name = "태연"
        idol.image = "image3.png"
        //DB에 접근하려면 딕셔너리로 변환을 시켜줘야 한다,
        
        let idoldic = idol.getDic()
        
        let db = Firestore.firestore()
        
        var ref : DocumentReference? = nil
        
        ref = db.collection("Idols").addDocument(data: idoldic) {
            error in
            if error != nil {
                print("error \(error!.localizedDescription)")
                self.Textview.text.append("\n쓰기 오류 발생")
            }
            else {
                print("도큐먼트 쓰기 성공")
                print("도큐먼트 아이디 : \(ref!.documentID)")
                self.Textview.text.append("\n도큐면트 쓰기 성공,")
            }
        }
    }
    
    func readListData() {
        let db = Firestore.firestore()
        
        db.collection("Idols").whereField("name", isEqualTo: "수지").getDocuments() {
            //후행 클로저
            (querySnapshot, error) in
            if error != nil {
                print("에러 \(error!.localizedDescription)")
                self.Textview.text.append("\n 읽기 오류 발생")
            }
            else {
                for documents in querySnapshot!.documents {
                    print("\(documents.documentID) => \(documents.data())")
                    
                    let dataDic = documents.data() as NSDictionary
                    let name = dataDic["name"] as? String ?? "이름없음" //?? 두개는 없을시 기본값지정
                    let image = dataDic["image"] as? String ?? "이미지없음"
                    
                    
                    //구조체로 데이터를 넣어준다.
                    var idol =  Idoldata()
                    idol.name = name
                    idol.image = image
                    self.idolArr.append( idol )
                    
                    
                }
                
                for idol in self.idolArr{
                    self.Textview.text.append("\n\(idol.name)")
                    self.Textview.text.append("\n\(idol.image)")
                }
            }
        }
        
    }
    
}
