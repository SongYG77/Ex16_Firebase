//
//  ViewController.swift
//  Ex16_Firebase
//
//  Created by 송윤근 on 2022/01/10.
//

//0. 기본 xcodeproj프로젝트 닫기
//1. 파인더에서 프로젝트 폴더 오른쪽 클릭해서 현재폴더에서 터미널 열기
//2. Cocoa Pod 유틸 설치
//   명령어 : sudo gem install cocoapods 엔터
//   Cocoa Pod 업데이트
//   명령어 : pod repo update 엔터
//3. 프로젝트 초기화
//   명령어 : pod init
//4. 라이브러리 설치
//   명령어: pod install
//5. 프로젝트 열기 : xcodeproj -> xcworkspace 열기
//   워크스페이스 열기 : 더블클릭 하거나 터미널 open 프로젝트이름.xcworkspace
//6. xcode에서 pod 파일을 편집하기( 라이브러리 목록 기술)
//7. 터미널에서 pod install 한번 더하기.

// 로그인 로그아웃에 관련된 것들은 가이드에 나와있기도 하다.

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    
    @IBOutlet weak var isloginLabel: UILabel!
    @IBOutlet weak var IdTextfield: UITextField!
    @IBOutlet weak var PWTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        updateUI()
    }
    
    func updateUI() {
        if let user = Auth.auth().currentUser {
            // 커런트 된 유저가 있다면
            //로그인 된 상태(세션을 지원?캐시?)
            isloginLabel.text = "로그인 상태 : \(user.email! )"
        } else {
            //nil이라 로그아웃 상태.
            isloginLabel.text = "로그인 상태 : 로그아웃"
            
        }
        
        
    }

    @IBAction func onBtnLogin(_ sender: UIButton) {
        if let textID = IdTextfield.text, let textPW = PWTextfield.text {
            
            if textID.count < 1 || textPW.count < 1 {
                print("아이디나 암호가 짧음")
                return
            }
            Auth.auth().signIn(withEmail: textID, password: textPW ) {
                //후행 클로저(마지막을 이런식으로 클로저
                [weak self] user, error in
                guard let _ = self else { return }
                
                print("로그인 완료")
                
                guard error == nil else{
                    
                    print(error!.localizedDescription)
                    return
                }
                let user = Auth.auth().currentUser
                print("\(String((user?.email)!)) , \(String(user!.uid))")
                
                self?.updateUI()
                
                
            }
            
        } else {
            print("login 계정 또는 암호 확인.")
        }
    }
    
    @IBAction func onBtnLogout(_ sender: UIButton) {
        
        let firebaseAuth = Auth.auth()
        
        do{
            try firebaseAuth.signOut()
            updateUI()
            
        } catch let signOutError as NSError{
            print("sign Error : \(signOutError)")
        }
    }
    
    @IBAction func onBtnJoin(_ sender: Any) {
        
        if let textID = IdTextfield.text, let textPW = PWTextfield.text{
            
            if textID.count < 1 || textPW.count < 1 {
                print("아이디나 암호가 짧음")
                return
            }
            
            Auth.auth().createUser(withEmail: textID, password: textPW) {
                authResult, error in
                
                guard let user = authResult?.user, error == nil else {
                    print (error!.localizedDescription)
                    return
                }
                
                print("회원가입 완료 \(user.email!)")
                print("\(user.uid)")
                
            }
            
        } else {
            print("아이디나 암호를 입력하세요")
        }
    }
    
    
}

