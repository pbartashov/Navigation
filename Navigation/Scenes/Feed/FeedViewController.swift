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

    var model: FeedViewControllerModelProtocol
    weak var coordinator: FeedCoordinator?

    //MARK: - Views

    private lazy var feedView = FeedView(delegate: self)

    //MARK: - LifeCicle

    init(model: FeedViewControllerModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    //MARK: - Metods

    private func initialize() {
        view.backgroundColor = .systemBackground

        view.addSubview(feedView)

        setupLayout()

        model.addCheckFailedObserver(self) { viewController, model in
            viewController.feedView.state = .wrong
        }

        model.addCheckPassedObserver(self) { viewController, model in
            viewController.feedView.state = .right
        }
    }

    private func setupLayout() {
        feedView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(Constants.padding)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-Constants.padding)
            make.centerY.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - ViewWithButtonDelegate methods
extension FeedViewController: ViewWithButtonDelegate {
    func buttonTapped(sender: UIButton) {
        switch sender.tag {
            case FeedView.Buttons.post1.hashValue:
                fallthrough
            case FeedView.Buttons.post2.hashValue:
                let post = Post(author: sender.currentTitle ?? "New post")

                coordinator?.showPost(post)
                
            case FeedView.Buttons.login.hashValue:
                if !feedView.text.isEmpty {
                    model.check(word: feedView.text)
                }

            default:
                break
        }
    }
}
