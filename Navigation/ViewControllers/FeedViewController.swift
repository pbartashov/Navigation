//
//  FeedViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 06.03.2022.
//

import UIKit

final class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.center = view.center
        button.tintColor = .black
        button.setTitle("Показать пост", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action:#selector(self.buttonTapped), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc
    func buttonTapped() {
        let post = Post(title: "Новый пост")
        let postViewController = PostViewController()
        postViewController.setup(with: post)
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
