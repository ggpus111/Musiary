//  PasswordChangeViewController.swift
//  Musiary
//  Created by 박다현

import UIKit
import FirebaseAuth

class PasswordChangeViewController: UIViewController {
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var newPasswordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 처음엔 에러 라벨 숨김
        newPasswordErrorLabel.isHidden = true
        confirmPasswordErrorLabel.isHidden = true
    }
    
    // MARK: - 저장 버튼 클릭
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let newPassword = newPasswordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""
        
        var hasError = false
        
        // 비밀번호 입력 확인
        if newPassword.isEmpty {
            newPasswordErrorLabel.text = "비밀번호가 입력되지 않았습니다."
            newPasswordErrorLabel.isHidden = false
            hasError = true
        } else {
            newPasswordErrorLabel.isHidden = true
        }
        
        // 비밀번호 일치 확인
        if newPassword != confirmPassword {
            confirmPasswordErrorLabel.text = "입력한 비밀번호가 일치하지 않습니다."
            confirmPasswordErrorLabel.isHidden = false
            hasError = true
        } else {
            confirmPasswordErrorLabel.isHidden = true
        }
        
        if hasError { return }
        
        // 비밀번호 길이 검사
        if newPassword.count < 6 {
            showAlert(message: "비밀번호는 최소 6자 이상이어야 합니다.")
            return
        }
        
        // 파이어베이스 비밀번호 변경
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                print("❌ 변경 실패: \(error.localizedDescription)")
                self.showAlert(message: "비밀번호 변경에 실패했습니다.")
            } else {
                self.showAlert(message: "비밀번호가 변경되었습니다.") {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    // MARK: - 로그아웃 버튼 클릭
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            print("🔓 로그아웃 완료")
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            
            // 로그인 화면으로 전환
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginView") as? LoginViewController {
                    sceneDelegate.changeRootViewController(loginVC, animated: true)
                }
            }
        } catch {
            print("❌ 로그아웃 실패:", error.localizedDescription)
            showAlert(message: "로그아웃에 실패했습니다.")
        }
    }
    
    // MARK: - 공통 알림
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
