//  AppUnlockViewController.swift
//  Musiary
//  Created by 박다현

import UIKit

class AppUnlockViewController: UIViewController {
    
    @IBOutlet weak var passwordLabel1: UILabel!
    @IBOutlet weak var passwordLabel2: UILabel!
    @IBOutlet weak var passwordLabel3: UILabel!
    @IBOutlet weak var passwordLabel4: UILabel!
    @IBOutlet weak var errorLabel: UILabel!  // ❌ 비밀번호가 틀렸습니다 (숨겨졌다가 표시됨)
    
    var input = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePasswordDots()
        errorLabel.isHidden = true
    }
    
    // ●●●● 업데이트
    func updatePasswordDots() {
        let labels = [passwordLabel1, passwordLabel2, passwordLabel3, passwordLabel4]
        for i in 0..<4 {
            labels[i]?.text = i < input.count ? "●" : ""
        }
    }
    
    // 숫자 버튼 (0~9)
    @IBAction func numberButtonTapped(_ sender: UIButton) {
        guard let digit = sender.titleLabel?.text, input.count < 4 else { return }
        input += digit
        updatePasswordDots()
        errorLabel.isHidden = true  // 오류 숨김
        
        if input.count == 4 {
            checkPassword()
        }
    }
    
    // 삭제 버튼: 마지막 문자 삭제
    @IBAction func deleteTapped(_ sender: UIButton) {
        guard !input.isEmpty else { return }
        input.removeLast()
        updatePasswordDots()
        errorLabel.isHidden = true
    }
    
    // 취소 버튼: 전체 초기화
    @IBAction func cancelTapped(_ sender: UIButton) {
        input = ""
        updatePasswordDots()
        errorLabel.isHidden = true
    }
    
    // 비밀번호 검증
    func checkPassword() {
        let savedPassword = UserDefaults.standard.string(forKey: "appLockPassword") ?? ""
        
        if input == savedPassword {
            dismiss(animated: true)  // ✅ 성공
        } else {
            input = ""
            updatePasswordDots()
            errorLabel.text = "❌ 비밀번호가 틀렸습니다"
            errorLabel.isHidden = false
        }
    }
}
