//  LoginViewController.swift
//  Musiary
//  Created by 박다현

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //placeholder 설정
        emailTextField.placeholder = "이메일을 입력하세요."
        passwordTextField.placeholder = "비밀번호를 입력하세요."
    }
    
    //로그인 버튼
    @IBAction func goLogin(_ sender: Any) {
        //입력값 검사
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            let alert = UIAlertController(title: "오류", message: "이메일과 비밀번호를 모두 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        //Firebase 로그인 시도
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // 실패 시 경고
                let alert = UIAlertController(title: "로그인 실패", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
                return
            }
            
            //로그인 성공 시: 로그인 상태 저장
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            
            //루트 뷰 전환
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
                    sceneDelegate.changeRootViewController(mainVC, animated: true)
                }
            }
        }
    }
    
    // 회원가입 이동
    @IBAction func goToSignUp(_ sender: UIButton) {
        guard let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpView") as? SignUpViewController else { return }
        present(signUpVC, animated: true)
    }
}
