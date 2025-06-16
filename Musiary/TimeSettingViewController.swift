//  TimeSettingViewController.swift
//  Musiary
//  Created by apple 박다현

import UIKit

import UIKit
import UserNotifications

class TimeSettingViewController: UIViewController {
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 이전에 저장된 알림 시간 불러오기
        if let savedDate = UserDefaults.standard.object(forKey: "alertTime") as? Date {
            timePicker.date = savedDate
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let isPushEnabled = UserDefaults.standard.bool(forKey: "pushEnabled")
        let selectedTime = timePicker.date
        
        // 푸시 알림이 꺼져 있을 경우 경고
        if !isPushEnabled {
            showAlert(message: "⚠️ 푸시 알림이 꺼져있어 알림이 울리지 않아요!")
            return
        }
        
        // 알림 시간 저장
        UserDefaults.standard.set(selectedTime, forKey: "alertTime")
        
        // 알림 예약
        scheduleNotification(at: selectedTime)
        dismiss(animated: true)
    }
    
    func scheduleNotification(at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "📝 오늘의 감정과 일기 작성하셨나요?"
        content.body = "오늘 하루를 기록해보세요!"
        content.sound = .default
        
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        dateComponents.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ 알림 등록 실패: \(error.localizedDescription)")
            } else {
                print("✅ 알림 등록 완료!")
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
