//  AppLockViewController.swift
//  Musiary
//  Created by 박다현

import UIKit

class AppLockViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var lockSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 저장된 상태 불러오기
        lockSwitch.isOn = UserDefaults.standard.bool(forKey: "appLockEnabled")
        passwordTextField.text = UserDefaults.standard.string(forKey: "appLockPassword")
        passwordTextField.keyboardType = .numberPad
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let isLockEnabled = lockSwitch.isOn
        let password = passwordTextField.text ?? ""

        if isLockEnabled {
            // 잠금 설정 O + 비번 미입력
            if password.isEmpty {
                showAlert("비밀번호가 입력되지 않았습니다.")
                return
            }
            if password.count != 4 || Int(password) == nil {
                showAlert("숫자 4자리로 입력해주세요.")
                return
            }

            UserDefaults.standard.set(true, forKey: "appLockEnabled")
            UserDefaults.standard.set(password, forKey: "appLockPassword")
        } else {
            UserDefaults.standard.set(false, forKey: "appLockEnabled")
        }

        dismiss(animated: true)
    }

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
