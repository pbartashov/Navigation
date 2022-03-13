//
//  FeedViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 06.03.2022.
//

import UIKit

final class FeedViewController: UIViewController {

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10

        return stack
    }()

    lazy private var showPost1Button: UIButton = {
        let button = createButton(withTitle: "Post 1")
        button.addTarget(self, action:#selector(self.buttonTapped), for: .touchUpInside)

        return button
    }()

    lazy private var showPost2Button: UIButton = {
        let button = createButton(withTitle: "Post 2")
        button.addTarget(self, action:#selector(self.buttonTapped), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        stackView.addArrangedSubview(showPost1Button)
        stackView.addArrangedSubview(showPost2Button)

        view.addSubview(stackView)

        setupLayout()
    }

    func setupLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: K.padding),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -K.padding),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    @objc
    func buttonTapped(sender: UIButton) {
        let post = Post(title: sender.currentTitle ?? "New post")
        let postViewController = PostViewController()
        postViewController.setup(with: post)
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
