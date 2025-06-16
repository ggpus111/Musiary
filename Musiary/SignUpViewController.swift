//  SignUpViewController.swift
//  Musiary
//  Created by 박다현


import UIKit
import FirebaseAuth  //Firebase 인증 사용


class SignUpViewController: UIViewController {
    
    //입력창
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordCheckTextField: UITextField!
    
    //오류 메시지
    @IBOutlet var emailErrorLabel: UILabel!
    @IBOutlet var passwordErrorLabel: UILabel!
    @IBOutlet var passwordCheckErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //초기 상태: 에러 문구 숨김
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        passwordCheckErrorLabel.isHidden = true
        
        //placeholder 설정
        emailTextField.placeholder = "이메일을 입력하세요."
        passwordTextField.placeholder = "비밀번호를 입력하세요."
        passwordCheckTextField.placeholder = "비밀번호를 다시 입력하세요."
    }
    
    //회원가입 버튼
    @IBAction func signUpTapped(_ sender: UIButton) {
        //에러 문구 초기화
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        passwordCheckErrorLabel.isHidden = true
        
        // 이메일 유효성 검사
        guard let email = emailTextField.text, !email.isEmpty else {
            emailErrorLabel.text = "이메일을 입력해주세요."
            emailErrorLabel.isHidden = false
            return
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let isEmailValid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        
        if !isEmailValid {
            emailErrorLabel.text = "올바르지 않은 이메일 형식입니다."
            emailErrorLabel.isHidden = false
            return
        }
        
        // 비밀번호 유효성 검사
        guard let password = passwordTextField.text, !password.isEmpty else {
            passwordErrorLabel.text = "비밀번호가 입력되지 않았습니다."
            passwordErrorLabel.isHidden = false
            return
        }
        
        guard let passwordCheck = passwordCheckTextField.text, passwordCheck == password else {
            passwordCheckErrorLabel.text = "비밀번호가 일치하지 않습니다."
            passwordCheckErrorLabel.isHidden = false
            return
        }
        
        //Firebase에 계정 생성 요청
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // 오류 발생 시 알림
                let alert = UIAlertController(title: "회원가입 실패", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
                return
            }
            
            //성공 시 → 로그인 화면으로 전환
            let alert = UIAlertController(title: "회원가입 완료", message: "로그인 화면으로 이동합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as? LoginViewController {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginVC, animated: true)
                }
            })
            self.present(alert, animated: true)
        }
    }
}
