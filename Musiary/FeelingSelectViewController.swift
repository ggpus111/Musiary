//  FeelingSelectViewController.swift
//  Musiary
//  Created by 박다현

import UIKit

protocol FeelingSelectDelegate: AnyObject {
    func didSelectFeeling(_ feeling: String)
}

class FeelingSelectViewController: UIViewController {
    
    weak var delegate: FeelingSelectDelegate?

    @IBOutlet var feelingButtons: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 버튼 타이틀 설정 (기분 태그 9개)
        let feelings = ["설렘", "기쁨", "행복", "그리움", "편안", "우울", "비참", "지침", "화남"]
        for (index, button) in feelingButtons.enumerated() where index < feelings.count {
            button.setTitle(feelings[index], for: .normal)
        }
    }

    @IBAction func feelingButtonTapped(_ sender: UIButton) {
        guard let feeling = sender.titleLabel?.text else { return }
        delegate?.didSelectFeeling(feeling)
        dismiss(animated: true)
    }
}
