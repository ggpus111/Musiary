//  CalendarViewController.swift
//  Musiary
//  Created by 박다현

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var writeDiaryImageView: UIImageView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var calendarImageView: UIImageView!
    @IBOutlet weak var settingsImageView: UIImageView!
    
    var currentDate = Date()
    var daysInMonth: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        collectionView.delegate = self
        collectionView.dataSource = self
        updateMonth()
    }
    
    // MARK: - 달력 관련
    func updateMonth() {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월"
        monthLabel.text = formatter.string(from: currentDate)
        
        daysInMonth = generateDays(for: currentDate)
        collectionView.reloadData()
    }
    
    func generateDays(for date: Date) -> [String] {
        var result: [String] = []
        
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)!
        let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let weekday = calendar.component(.weekday, from: firstDay)
        
        // 공백 추가 (1일 전까지)
        result += Array(repeating: "", count: weekday - 1)
        result += range.map { String($0) }
        
        return result
    }
    
    @IBAction func prevMonth(_ sender: UIButton) {
        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        updateMonth()
    }
    
    @IBAction func nextMonth(_ sender: UIButton) {
        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        updateMonth()
    }
    
    // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath)
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = daysInMonth[indexPath.item]
        }
        return cell
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
