//  SceneDelegate.swift
//  Musiary
//  Created by 박다현

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window = UIWindow(windowScene: windowScene)

        //Firebase 로그인 상태 확인
        if Auth.auth().currentUser != nil {
            // 로그인된 상태 → MainView로 이동
            guard let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }
            window?.rootViewController = mainVC
        } else {
            // 로그인되지 않음 → LoginView로 이동
            guard let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginView") as? LoginViewController else { return }
            window?.rootViewController = loginVC
        }

        window?.makeKeyAndVisible()
    }

    func changeRootViewController(_ vc: UIViewController, animated: Bool) {
        guard let window = self.window else { return }
        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.4, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
}
