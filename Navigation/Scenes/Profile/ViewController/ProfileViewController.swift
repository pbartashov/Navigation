//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 10.03.2022.
//

import UIKit
import StorageService
import iOSIntPackage

final class ProfileViewController<ViewModelType: ProfileViewModelProtocol>: UIViewController,
                                                                            UITableViewDataSource,
                                                                            UITableViewDelegate {
    //MARK: - Properties

    private var viewModel: ViewModelType

    private var isAvatarPresenting: Bool = false {
        didSet {
            tableView.isUserInteractionEnabled = !isAvatarPresenting
        }
    }

    private var currentColorFilter: ColorFilter? {
        didSet {
            for (i, post) in viewModel.posts.enumerated() {
                let indexPath = IndexPath(row: i, section: isProfileHidden ? 0 : 1)

                if let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell {
                    cell.setup(with: post, filter: currentColorFilter)
                }
            }
        }
    }

    var isProfileHidden = false {
        didSet {
            view.setNeedsLayout()
        }
    }

    var isPhotoCellHidden = false {
        didSet {
            view.setNeedsLayout()
        }
    }

    //MARK: - Views

    private weak var avatar: UIView?
    private weak var coverView: UIView?
    private weak var closeAvatarPresentationButton: UIButton?

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


        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        tableView.addGestureRecognizer(doubleTap)


        return tableView
    }()

    private lazy var profileHeaderView: ProfileHeaderView = {

        let profileHeaderView = ProfileHeaderView(delegate: self)
        profileHeaderView.setup(with: viewModel.user)

        return profileHeaderView
    }()

    private lazy var photosTableViewCell = PhotosTableViewCell()

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

    //MARK: - LifeCicle

    init(viewModel: ViewModelType) {
        self.viewModel = viewModel

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

        setupViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        let photos = Photos.randomPhotos(ofCount: photosTableViewCell.photosCount)
        photosTableViewCell.setup(with: photos)

        viewModel.perfomAction(.requstPosts)
    }

    override func viewSafeAreaInsetsDidChange() {
        if isAvatarPresenting {
            moveAndScaleAvatarToCenter()
        }
    }

    //MARK: - Metods

    private func setupViewModel() {
        viewModel.stateChanged = { [weak self] state in
            switch state {
                case .initial:
                    break
                case .loaded(_):
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
            }
        }
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

    private func moveAndScaleAvatarToCenter() {
        guard let avatar = avatar else {
            return
        }

        let layoutFrame = view.safeAreaLayoutGuide.layoutFrame
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

        let button = ClosureBasedButton()
        button.tintColor = .black
        button.alpha = 0.0
        button.tapAction =  { [weak self] in self?.closeAvatarPresentation() }

        let configuration = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "xmark", withConfiguration: configuration)
        button.setImage(image, for: .normal)

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

    private func closeAvatarPresentation() {
        let duration = 0.8

        UIView.animateKeyframes(withDuration: duration, delay: 0.0,
                                animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0,
                               relativeDuration: 0.3 / duration) {

                self.closeAvatarPresentationButton?.alpha = 0.0
            }

            UIView.addKeyframe(withRelativeStartTime: 0.3 / duration,
                               relativeDuration: 0.5 / duration ) { [weak self] in
                guard let self = self, let avatar = self.avatar else { return }

                self.coverView?.alpha = 0.0
                avatar.transform = .identity
                avatar.layer.cornerRadius = avatar.bounds.width / 2
            }
        }, completion: { [self] _ in

            coverView?.removeFromSuperview()
            closeAvatarPresentationButton?.removeFromSuperview()
            avatar = nil
            isAvatarPresenting = false
        }
        )
    }

    @objc func handleDoubleTap(recognizer: UIGestureRecognizer) {
        let tappedPoint = recognizer.location(in: tableView)

        if let indexPath = tableView.indexPathForRow(at: tappedPoint) {
            tableView.deselectRow(at: indexPath, animated: true)

            let post = viewModel.posts[indexPath.row]
            viewModel.perfomAction(.selected(post: post))
        }
    }

    // MARK: - UITableViewDataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        isProfileHidden ? 1 : 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (isProfileHidden || section > 0) ? viewModel.posts.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0, isPhotoCellHidden == false {
            return photosTableViewCell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier,
                                                 for: indexPath)
        as! PostTableViewCell

        cell.setup(with: viewModel.posts[indexPath.row], filter: currentColorFilter)

        return cell
    }

    // MARK: - UITableViewDelegate methods
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        (isProfileHidden || section > 0) ? nil : profileHeaderView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath == IndexPath(row: 0, section: 0) {
            viewModel.perfomAction(.showPhotos)
        }
    }
}

// MARK: - ProfileHeaderViewDelegate methods
extension ProfileViewController: ProfileHeaderViewDelegate {
    func statusButtonTapped() {
        viewModel.user?.status = profileHeaderView.statusText
        profileHeaderView.setup(with: viewModel.user)
    }
    
    func avatarTapped(sender: UIView) {
        isAvatarPresenting = true
        
        createCover()

        avatar = sender
        profileHeaderView.bringSubviewToFront(sender)

        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.coverView?.alpha = 0.5
            self?.avatar?.layer.cornerRadius = 0
            self?.moveAndScaleAvatarToCenter()
        } completion: { _ in
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.closeAvatarPresentationButton?.alpha = 1
            }
        }
    }
}
