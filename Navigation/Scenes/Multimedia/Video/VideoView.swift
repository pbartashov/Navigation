//
//  VideoView.swift
//  Navigation
//
//  Created by Павел Барташов on 16.07.2022.
//

import UIKit
import WebKit

final class VideoView: UIView {

    // MARK: - Properties
    weak var delegate: UITableViewDelegate? {
        didSet {
            tableView.delegate = delegate
        }
    }

    weak var dataSource: UITableViewDataSource? {
        didSet {
            tableView.dataSource = dataSource
        }
    }

    // MARK: - Views

    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .init(x: 0, y: 0, width: 100, height: 100),
                                configuration: webConfiguration)

        let html = """
        <html>
        <head>
        <style>
        .center {
        padding: 70px 0;
        text-align: center;
        }
        </style>
        </head>
        <body>
        <div class="center">
        <h1>Выберите видео из списка:</h1>
        </div>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)

        return webView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        
        return tableView
    }()

    // MARK: - LifeCicle

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Metods

    private func initialize() {
        addSubviews(webView, tableView)

        setupLayouts()
    }

    private func setupLayouts() {
        webView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(webView.snp.height).multipliedBy(16.0/9.0)
            make.width.equalToSuperview().priority(700)
            make.height.lessThanOrEqualTo(self.snp.height).multipliedBy(0.5)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom).offset(Constants.padding)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    func updateWebView(with url: String?) {
        guard let url = url else { return }
        webView.loadVideoFromYouTube(for: url)
    }
}
