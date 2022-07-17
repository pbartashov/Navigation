//
//  VideoViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 16.07.2022.
//

import UIKit

final class VideoViewController: UIViewController {

    // MARK: - Properties

    var videos: [VideoTrack] = VideoTrack.demoVideos

    // MARK: - Views

    private lazy var videoView: VideoView = {
        $0.delegate = self
        $0.dataSource = self

        return $0
    }(VideoView())

    // MARK: - LifeCicle

    init(viewModel: [VideoTrack]) {
        self.videos = viewModel

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
        view.backgroundColor = .white
        view.addSubview(videoView)
        setupLayout()
    }

    private func setupLayout() {
        videoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Table view data source
extension VideoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = videos[indexPath.row].title

        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

// MARK: - Table view delegate
extension VideoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        videoView.updateWebView(with: videos[indexPath.row].videoID)
    }
}
