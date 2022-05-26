//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 10.03.2022.
//

import UIKit
import StorageService

final class ProfileViewController: UIViewController {

    private let posts: [Post] = Post.demoPosts

    private var profile = Profile(name: "Octopus",
                                  image: (UIImage(named: "profileImage") ?? UIImage(systemName: "person"))!,
                                  status: "Hardly coding")

    private weak var coverView: UIView?
    private weak var closeAvatarPresentationButton: UIButton?
    private var isAvatarPresenting: Bool = false {
        didSet {
            tableView.isUserInteractionEnabled = !isAvatarPresenting
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)

        tableView.register(PostTableViewCell.self,
                           forCellReuseIdentifier: PostTableViewCell.identifier)

        tableView.dataSource = self
        tableView.delegate = self

#if DEBUG
        tableView.backgroundColor = .systemTeal
#else
        tableView.backgroundColor = .systemOrange
#endif

        return tableView
    }()

    private lazy var profileHeaderView: ProfileHeaderView = {

        let profileHeaderView = ProfileHeaderView()
        profileHeaderView.setup(with: profile)

        profileHeaderView.setStatusButton.addTarget(self,
                                                    action:#selector(setStatusButtonClicked),
                                                    for: .touchUpInside)

        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(showAvatarPresentation))

        profileHeaderView.avatarImageView.addGestureRecognizer(tapRecognizer)
        profileHeaderView.avatarImageView.isUserInteractionEnabled = true

        return profileHeaderView
    }()

    private lazy var photosTableViewCell = PhotosTableViewCell()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6

        view.addSubviewsToAutoLayout(tableView)

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        let photos = Photos.randomPhotos(ofCount: photosTableViewCell.photosCount)
        photosTableViewCell.setup(with: photos)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc
    private func setStatusButtonClicked() {
        if let text = profileHeaderView.statusTextField.text {
            profile.status = text
            profileHeaderView.setup(with: profile)
        }
    }

    @objc
    private func showAvatarPresentation() {
        isAvatarPresenting = true

        createCover()

        let avatar = profileHeaderView.avatarImageView

        profileHeaderView.bringSubviewToFront(avatar)

        UIView.animate(withDuration: 0.5) { [self] in
            coverView?.alpha = 0.5
            avatar.layer.cornerRadius = 0
            moveAndScaleAvatarToCenterWith()
        } completion: { _ in
            UIView.animate(withDuration: 0.3) { [self] in
                closeAvatarPresentationButton?.alpha = 1
            }
        }
    }

    override func viewSafeAreaInsetsDidChange() {
        if isAvatarPresenting {
            moveAndScaleAvatarToCenterWith()
        }
    }

    private func moveAndScaleAvatarToCenterWith() {
        let layoutFrame = view.safeAreaLayoutGuide.layoutFrame
        let avatar = profileHeaderView.avatarImageView
        let scale = min(layoutFrame.size.width, layoutFrame.size.height) / avatar.bounds.width

        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
        let translateTransform = CGAffineTransform(translationX: layoutFrame.midX - avatar.center.x,
                                                   y: layoutFrame.midY - avatar.center.y)

        avatar.transform = scaleTransform.concatenating(translateTransform)
    }

    private func createCover() {
        let cover = UIView()
        cover.backgroundColor = .white
        cover.alpha = 0.0

        let button = UIButton()
        button.tintColor = .black
        button.alpha = 0.0

        let configuration = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "xmark", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.addTarget(self,
                         action: #selector(closeAvatarPresentation),
                         for: .touchUpInside)

        view.addSubviewsToAutoLayout(button)
        profileHeaderView.addSubviewsToAutoLayout(cover)

        NSLayoutConstraint.activate([
            cover.topAnchor.constraint(equalTo: view.topAnchor),
            cover.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cover.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cover.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
             button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.padding)
        ])

        self.coverView = cover
        self.closeAvatarPresentationButton = button
    }

    @objc
    private func closeAvatarPresentation() {
        let duraration = 0.8
        let avatar = profileHeaderView.avatarImageView

        UIView.animateKeyframes(withDuration: duraration, delay: 0.0,
                                animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0,
                               relativeDuration: 0.3 / duraration) {

                self.closeAvatarPresentationButton?.alpha = 0.0
            }

            UIView.addKeyframe(withRelativeStartTime: 0.3 / duraration,
                               relativeDuration: 0.5 / duraration ) {
                self.coverView?.alpha = 0.0
                avatar.transform = .identity
                avatar.layer.cornerRadius = avatar.bounds.width / 2
            }
        }, completion: { [self]_ in

            coverView?.removeFromSuperview()
            closeAvatarPresentationButton?.removeFromSuperview()
            isAvatarPresenting = false
        }
        )
    }
}

// MARK: - UITableViewDataSource methods
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return photosTableViewCell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier,
                                                 for: indexPath)
            as! PostTableViewCell

        cell.setup(with: posts[indexPath.row])

        return cell
    }
}

// MARK: - UITableViewDelegate methods
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        section == 0 ? profileHeaderView : nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            tableView.deselectRow(at: indexPath, animated: true)

            let photosViewController = PhotosViewController()
            navigationController?.pushViewController(photosViewController, animated: true)
        }
    }
}
