//
//  PostViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 06.03.2022.
//

import UIKit
import StorageService

final class PostViewController: UIViewController {

    //MARK: - Properties

    weak var coordinator: PostCoordinator?

    //MARK: - LifeCicle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemYellow

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(infoButtonTapped))
    }

    //MARK: - Metods

    func setup(with post: Post) {
        title = post.author
    }

    @objc func infoButtonTapped() {
        coordinator?.showInfo()
    }
}
