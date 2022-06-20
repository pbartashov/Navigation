//
//  FeedViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 06.03.2022.
//

import UIKit
import StorageService

final class FeedViewController: UIViewController {
    
    //MARK: - Properties

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10

        return stack
    }()

    private lazy var showPost1Button: ClosureBasedButton = {
        let button = ViewFactory.create.button(withTitle: "Post 1")
        button.tapActionWithSender = buttonTapped

        return button
    }()

    private lazy var showPost2Button: ClosureBasedButton = {
        let button = ViewFactory.create.button(withTitle: "Post 2")
        button.tapActionWithSender = buttonTapped

        return button
    }()

    //MARK: - LifeCicle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        stackView.addArrangedSubview(showPost1Button)
        stackView.addArrangedSubview(showPost2Button)

        view.addSubview(stackView)

        setupLayout()
    }

    //MARK: - Metods

    func setupLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.padding),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.padding),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    func buttonTapped(sender: UIButton) {
        let post = Post(author: sender.currentTitle ?? "New post",
                        description: "",
                        image: "",
                        likes: 0,
                        views: 0)
        let postViewController = PostViewController()
        postViewController.setup(with: post)
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
