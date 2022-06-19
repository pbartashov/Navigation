//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 10.03.2022.
//

import UIKit
import StorageService
import iOSIntPackage

final class ProfileViewController: UIViewController {

    private let posts: [Post] = Post.demoPosts

    private let userService: UserService
    private let userName: String
    private var user: User? {
        userService.getUser(byName: userName)
    }

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

        if let user = user {
            profileHeaderView.setup(with: user)
        }

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

    private var currentColorFilter: ColorFilter? {
        didSet {
            for (i, post) in posts.enumerated() {
                let indexPath = IndexPath(row: i, section: 1)

                if let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell {
                    cell.setup(with: post, filter: currentColorFilter)
                }
            }
        }
    }

    private lazy var colorFilterSelecor: UISegmentedControl = {
        let off = UIAction(title: "Выкл") { _ in self.currentColorFilter = nil }
        let chrome = UIAction(title: "Нуар") { _ in self.currentColorFilter = .noir }
        let motionBlur = UIAction(title: "Размытие") { _ in
            self.currentColorFilter = .motionBlur(radius: 10)
        }
        let fade = UIAction(title: "Инверсия") { _ in self.currentColorFilter = .colorInvert }

        let control = UISegmentedControl(items: [off,
                                                 chrome,
                                                 motionBlur,
                                                 fade])
        control.selectedSegmentIndex = 0

        return control
    }()

    init(userService: UserService, userName: String) {
        self.userService = userService
        self.userName = userName

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6

        view.addSubview(colorFilterSelecor)
        view.addSubview(tableView)

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        let photos = Photos.randomPhotos(ofCount: photosTableViewCell.photosCount)
        photosTableViewCell.setup(with: photos)
    }

    private func setupLayout() {
        colorFilterSelecor.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(colorFilterSelecor.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    @objc
    private func setStatusButtonClicked() {
        if let text = profileHeaderView.statusTextField.text,
           let user = user {
            user.status = text
            profileHeaderView.setup(with: user)
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
            moveAndScaleAvatarToCenter()
        } completion: { _ in
            UIView.animate(withDuration: 0.3) { [self] in
                closeAvatarPresentationButton?.alpha = 1
            }
        }
    }

    override func viewSafeAreaInsetsDidChange() {
        if isAvatarPresenting {
            moveAndScaleAvatarToCenter()
        }
    }

    private func moveAndScaleAvatarToCenter() {
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

        view.addSubview(button)
        profileHeaderView.addSubview(cover)

        cover.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        button.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.padding)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-Constants.padding)
        }

        self.coverView = cover
        self.closeAvatarPresentationButton = button
    }

    @objc
    private func closeAvatarPresentation() {
        let duration = 0.8
        let avatar = profileHeaderView.avatarImageView

        UIView.animateKeyframes(withDuration: duration, delay: 0.0,
                                animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0,
                               relativeDuration: 0.3 / duration) {

                self.closeAvatarPresentationButton?.alpha = 0.0
            }

            UIView.addKeyframe(withRelativeStartTime: 0.3 / duration,
                               relativeDuration: 0.5 / duration ) {
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

        cell.setup(with: posts[indexPath.row], filter: currentColorFilter)

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
