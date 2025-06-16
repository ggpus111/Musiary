//  MainViewController.swift
//  Musiary
//  Created by 박다현

import UIKit

class MainViewController: UIViewController, FeelingSelectDelegate {
    
    @IBOutlet var songTitleLabel: UILabel!
    @IBOutlet var songMessageLabel: UILabel!
    @IBOutlet var albumImageView: UIImageView!
    @IBOutlet var quotesLabel: UILabel!
    @IBOutlet var feelingImageView: UIImageView!
    @IBOutlet var feelingLabel: UILabel!
    @IBOutlet var weekDateLabels: [UILabel]!
    @IBOutlet var weekdayLabels: [UILabel]!
    @IBOutlet var weekdayStackView: UIStackView!
    @IBOutlet var weekDateStackView: UIStackView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var writeDiaryImageView: UIImageView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var calendarImageView: UIImageView!
    @IBOutlet weak var settingsImageView: UIImageView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            updateSongRecommendation()
            configureTabBar() // ✅ 수정: selectedTab 매개변수 제거
            
            // 기분 선택 탭
            let feelingTapGesture = UITapGestureRecognizer(target: self, action: #selector(showFeelingSelector))
            feelingImageView.isUserInteractionEnabled = true
            feelingImageView.addGestureRecognizer(feelingTapGesture)
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

        // MARK: - 기분 선택
        @objc func showFeelingSelector() {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "FeelingSelectView") as? FeelingSelectViewController else { return }
            vc.modalPresentationStyle = .pageSheet
            vc.delegate = self
            present(vc, animated: true)
        }

        func didSelectFeeling(_ feeling: String) {
            feelingLabel.text = feeling
            showQuote(from: [feeling])
        }
    
    // MARK: - 추천 명언
    
    let quoteDatabase: [String: [String]] = [
        "설렘": ["두근거림은 살아있다는 증거야.", "작은 설렘이 하루를 바꿔줄 수 있어."],
        "기쁨": ["기쁨은 나누면 배가 돼!", "웃는 네가 제일 예뻐!"],
        "행복": ["행복은 지금 이 순간에도 널 기다려.", "너는 이미 많은 걸 가지고 있어."],
        "그리움": ["그리움은 사랑의 또 다른 이름이야.", "그때의 네가 지금도 소중해."],
        "편안": ["오늘은 그냥 숨 쉬는 것도 잘한 거야.", "편안함도 너의 능력이야."],
        "우울": ["괜찮아, 울어도 돼.", "오늘 하루 버틴 너는 충분히 대단해."],
        "비참": ["지금 느끼는 감정도 네 일부야.", "비참함 속에서도 빛나는 너가 있어."],
        "지침": ["쉬어도 괜찮아. 네 몸이 하는 말이야.", "지쳤을 땐 스스로를 안아줘."],
        "화남": ["화난 너도 괜찮아.", "감정은 느낄 수 있는 거니까 소중해."]
    ]
    
    func showQuote(from selectedTags: [String]) {
        var quotes: [String] = []
        for tag in selectedTags {
            if let messages = quoteDatabase[tag] {
                quotes += messages
            }
        }
        quotesLabel.text = quotes.randomElement() ?? "오늘 하루도 수고했어요 💗"
    }
    
    // MARK: - 노래 추천
    
    func updateSongRecommendation() {
        let diarySaved = UserDefaults.standard.bool(forKey: "diarySaved")
        songTitleLabel.text = "오늘의 추천 노래 🎵"
        if diarySaved {
            songMessageLabel.text = "아이유 - 밤편지"
            albumImageView.image = UIImage(named: "album_nightletter")
        } else {
            songMessageLabel.text = "일기를 작성해주세요!\n작성 후 노래를 추천해드려요!"
            albumImageView.image = UIImage(named: "레코드 판")
        }
    }
    
    // MARK: - 캘린더 UI
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCalendar()
    }
    
    func updateCalendar() {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.firstWeekday = 1
        let today = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월"
        monthLabel.text = dateFormatter.string(from: today)
        
        let weekday = calendar.component(.weekday, from: today)
        let daysFromSunday = weekday - calendar.firstWeekday
        guard let weekStart = calendar.date(byAdding: .day, value: -daysFromSunday, to: today) else { return }
        
        for (index, label) in weekDateLabels.enumerated() {
            if let date = calendar.date(byAdding: .day, value: index, to: weekStart) {
                let day = calendar.component(.day, from: date)
                label.text = "\(day)"
                
                if calendar.isDate(date, inSameDayAs: today) {
                    label.backgroundColor = UIColor.systemGray
                    label.textColor = .white
                    label.layer.cornerRadius = label.frame.size.height / 2
                    label.layer.masksToBounds = true
                    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
                    label.textAlignment = .center
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.widthAnchor.constraint(equalToConstant: 40).isActive = true
                    label.heightAnchor.constraint(equalToConstant: 40).isActive = true
                } else {
                    label.backgroundColor = .clear
                    label.textColor = .black
                    label.layer.cornerRadius = 0
                    label.font = UIFont.systemFont(ofSize: 16)
                    label.textAlignment = .center
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSongRecommendation()
    }
}
