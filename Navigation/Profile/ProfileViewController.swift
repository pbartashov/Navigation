//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 10.03.2022.
//

import UIKit

final class ProfileViewController: UIViewController {

    private let posts: [Post] = Post.demoPosts

    private var profile = Profile(name: "Octopus",
                                  image: (UIImage(named: "profileImage") ?? UIImage(systemName: "person"))!,
                                  status: "Hardly coding")

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)

        tableView.register(PostTableViewCell.self,
                           forCellReuseIdentifier: PostTableViewCell.identifier)

        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    lazy private var profileHeaderView: ProfileHeaderView = {

        let profileHeaderView = ProfileHeaderView()
        profileHeaderView.setup(with: profile)

        profileHeaderView.setStatusButton.addTarget(self,
                                                    action:#selector(self.setStatusButtonClicked),
                                                    for: .touchUpInside)

        return profileHeaderView
    }()

    lazy private var photosTableViewCell = PhotosTableViewCell()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6

        view.addSubview(tableView)

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        let photos = Photos.randomPhotos(ofCount: photosTableViewCell.photosCount)
        photosTableViewCell.setup(with: photos)
    }

    func setupLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc
    func setStatusButtonClicked() {
        if let text = profileHeaderView.statusTextField.text {
            profile.status = text
            profileHeaderView.setup(with: profile)
        }
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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        section == 0 ? profileHeaderView : nil
    }
}

// MARK: - UITableViewDelegate methods
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            tableView.deselectRow(at: indexPath, animated: true)

            let photosViewController = PhotosViewController()
            navigationController?.pushViewController(photosViewController, animated: true)
        }
    }
}
