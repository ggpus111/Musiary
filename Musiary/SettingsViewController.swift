// SettingsViewController.swift
//  Musiary
//  Created by 박다현

import UIKit
import FirebaseAuth
import UserNotifications

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var pushSwitch: UISwitch!
    
    // 메뉴바 아이콘들
    @IBOutlet weak var writeDiaryImageView: UIImageView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var calendarImageView: UIImageView!
    @IBOutlet weak var settingsImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 로그인된 이메일 표시
        if let user = Auth.auth().currentUser {
            emailLabel.text = user.email
        }
        
        pushSwitch.isOn = UserDefaults.standard.bool(forKey: "pushEnabled")
        
        configureTabBar()
    }
    
    // MARK: - 푸시 알림 스위치 변경
    @IBAction func pushSwitchChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "pushEnabled")
        
        if sender.isOn {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                print(granted ? "🔔 알림 허용됨" : "🚫 알림 거부됨")
            }
        } else {
            print("알림 비활성화됨")
        }
    }
    
    // MARK: - 팝업 메뉴 항목
    @IBAction func openPasswordChange(_ sender: UIButton) {
        presentPopup("PasswordAuthViewController")
    }
    
    @IBAction func openTimeSetting(_ sender: UIButton) {
        presentPopup("TimeSettingViewController")
    }
    
    @IBAction func openAppLockSetting(_ sender: UIButton) {
        presentPopup("AppLockViewController")
    }
    
    func presentPopup(_ identifier: String) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: identifier) else { return }
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
    
    // MARK: - 메뉴바 구성 함수
    func configureTabBar() {
        writeDiaryImageView.image = UIImage(named: "write")
        writeDiaryImageView.isUserInteractionEnabled = true
        writeDiaryImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDiaryPopup)))
        
        homeImageView.image = UIImage(named: "home")
        homeImageView.isUserInteractionEnabled = true
        homeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToHome)))
        
        calendarImageView.image = UIImage(named: "calendar")
        calendarImageView.isUserInteractionEnabled = true
        calendarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToCalendar)))
        
        settingsImageView.image = UIImage(named: "settings")
        settingsImageView.isUserInteractionEnabled = true
        settingsImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToSettings)))
    }
    
    @objc func showDiaryPopup() {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "DiaryViewController") as? DiaryViewController else { return }
            vc.modalPresentationStyle = .pageSheet
            present(vc, animated: true)
        }

        @objc func goToHome() {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }

        @objc func goToCalendar() {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController else { return }
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }

    @objc func goToSettings() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
}
