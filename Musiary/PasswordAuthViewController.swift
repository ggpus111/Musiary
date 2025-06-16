//  PasswordAuthViewController.swift
//  Musiary
//  Created by 박다현


import UIKit
import FirebaseAuth

class PasswordAuthViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""
    }

    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        guard let password = passwordTextField.text,
              let email = Auth.auth().currentUser?.email else { return }

        let credential = EmailAuthProvider.credential(withEmail: email, password: password)

        Auth.auth().currentUser?.reauthenticate(with: credential) { result, error in
            if let error = error {
                self.errorLabel.text = "❌ 비밀번호가 틀렸습니다."
                print("Reauthentication failed: \(error.localizedDescription)")
            } else {
                // 비밀번호가 맞으면 비밀번호 변경 화면으로 전환
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeViewController") else { return }
                vc.modalPresentationStyle = .pageSheet
                self.present(vc, animated: true)
            }
        }
    }
}
