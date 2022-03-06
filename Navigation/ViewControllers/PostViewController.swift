//
//  PostViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 06.03.2022.
//

import UIKit

final class PostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemYellow

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Инфо",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(infoButtonTapped))
    }

    func setup(with post:Post) {
        title = post.title
    }

    @objc
    func infoButtonTapped() {
        let infoViewController = InfoViewController()
        present(infoViewController, animated: true, completion: nil)
    }
}
