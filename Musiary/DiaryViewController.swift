//  DiaryViewController.swift
//  Musiary
//  Created by 박다현

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DiaryViewController: UIViewController {
    
    let placeholderText = "나에게 오늘 무슨일이 있었지?"
    var isPlaceholderVisible = false
    
    @IBOutlet weak var diaryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diaryTextView.delegate = self
        
        //폰트 및 여백 설정
        diaryTextView.font = UIFont.systemFont(ofSize: 17)
        diaryTextView.textContainerInset.top = 12
        diaryTextView.textContainer.lineFragmentPadding = 12
        
        //줄무늬 배경 적용 (24pt 간격)
        if let backgroundImage = UIImage.linedBackgroundImage(size: CGSize(width: 1, height: 24)) {
            let bgImageView = UIImageView(image: backgroundImage)
            bgImageView.frame = diaryTextView.bounds
            bgImageView.contentMode = .scaleToFill
            bgImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            diaryTextView.addSubview(bgImageView)
            diaryTextView.sendSubviewToBack(bgImageView)
        }
        
        //플레이스홀더 또는 임시 저장된 텍스트 불러오기
        if let savedText = UserDefaults.standard.string(forKey: "diaryDraft"), !savedText.isEmpty {
            diaryTextView.text = savedText
            diaryTextView.textColor = .black
            isPlaceholderVisible = false
        } else {
            diaryTextView.text = placeholderText
            diaryTextView.textColor = .lightGray
            isPlaceholderVisible = true
        }
    }
        
    func saveDraft(_ text: String) {
        UserDefaults.standard.set(text, forKey: "diaryDraft")
    }

    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
                let text = diaryTextView.text ?? ""
                
                //플레이스홀더 상태면 저장 안 함
                if isPlaceholderVisible { return }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let today = dateFormatter.string(from: Date())
                
                let db = Firestore.firestore()
                db.collection("diaries").document(uid).collection("entries").document(today).setData([
                    "text": text,
                    "timestamp": Timestamp(date: Date())
                ]) { error in
                    if let error = error {
                        print("저장 실패: \(error.localizedDescription)")
                    } else {
                        print("저장 성공!")
                        UserDefaults.standard.removeObject(forKey: "diaryDraft")
                        UserDefaults.standard.set(true, forKey: "diarySaved")
                        self.dismiss(animated: true)
                    }
                }
            }
        }

        //UITextViewDelegate 따로 확장
        extension DiaryViewController: UITextViewDelegate {
            
            func textViewDidBeginEditing(_ textView: UITextView) {
                if isPlaceholderVisible {
                    textView.text = ""
                    textView.textColor = .black
                    isPlaceholderVisible = false
                }
            }

            func textViewDidEndEditing(_ textView: UITextView) {
                if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    textView.text = placeholderText
                    textView.textColor = .lightGray
                    isPlaceholderVisible = true
                }
            }

            func textViewDidChange(_ textView: UITextView) {
                saveDraft(textView.text)
            }
        }

//줄무늬 배경 이미지 생성 기능 추가
extension UIImage {
    static func linedBackgroundImage(size: CGSize = CGSize(width: 1, height: 20),
                                     lineColor: UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        lineColor.setFill()
        context.fill(CGRect(x: 0, y: size.height - 1, width: size.width, height: 1)) // 1px 줄
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.resizableImage(withCapInsets: .zero, resizingMode: .tile)
    }
}
