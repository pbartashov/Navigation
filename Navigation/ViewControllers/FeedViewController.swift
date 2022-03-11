//
//  FeedViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 06.03.2022.
//

import UIKit

final class FeedViewController: UIViewController {

    lazy private var buttonShowPost: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.tintColor = .black
        button.setTitle("Show post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action:#selector(self.buttonTapped), for: .touchUpInside)
        button.center = self.view.center
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(buttonShowPost)
    }

    @objc
    func buttonTapped() {
        let post = Post(title: "Новый пост")
        let postViewController = PostViewController()
        postViewController.setup(with: post)
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
