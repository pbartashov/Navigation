//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 10.03.2022.
//

import UIKit

final class ProfileViewController: UIViewController {

    private var profile = Profile(name: "Octopus",
                          image: (UIImage(named: "ProfileImage") ?? UIImage(systemName: "person"))!,
                          status: "Hardly coding")

    lazy private var profileHeaderView: ProfileHeaderView = {
        let profileHeaderView = ProfileHeaderView()

        profileHeaderView.buttonSetStatus.addTarget(self,
                                                     action:#selector(self.buttonSetStatus),
                                                     for: .touchUpInside)

        profileHeaderView.statusTextField.addTarget(self,
                                                    action: #selector(self.statusTextDidChanged(_:)),
                                                    for: .editingChanged)
        return profileHeaderView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"

        view.addSubview(profileHeaderView)

        profileHeaderView.setup(with: profile)
    }

    override func viewWillLayoutSubviews() {

        profileHeaderView.frame = view.frame
        profileHeaderView.setViewFrames()
        //Вообще логичнее было бы привязвать View для заголовка профиля к SafeArea,
        //а не ко всему корневому view контроллера. Что-то типа такого:
        //profileHeaderView.frame = view.frame.inset(by: view.safeAreaInsets)
    }

    @objc
    func buttonSetStatus() {
        profileHeaderView.setup(with: profile)
    }

    @objc
    func statusTextDidChanged(_ textField: UITextField) {
        if let text = textField.text {
            profile.status = text
        }
    }
}
