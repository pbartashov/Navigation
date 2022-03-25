//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Павел Барташов on 20.03.2022.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    static var identifier: String {
        String(describing: PostTableViewCell.self)
    }

    private let authorLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2

        return label
    }()

    private let postImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black

        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0

        return label
    }()


    private let likesLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black

        return label
    }()

    private let viewsLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.textAlignment = .right

        return label
    }()

    lazy private var likesAndViewsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [likesLabel, viewsLabel])

        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually

        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func initialize() {
       [authorLabel,
         postImageView,
         descriptionLabel,
         likesAndViewsStack].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        setupLayouts()
    }

    private func setupLayouts() {
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),

            postImageView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 12),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: Constants.padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor),

            likesAndViewsStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.padding),
            likesAndViewsStack.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            likesAndViewsStack.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor),

            contentView.bottomAnchor.constraint(equalTo: likesAndViewsStack.bottomAnchor)
        ])
    }

    func setup(with post: Post) {
        authorLabel.text = post.author
        descriptionLabel.text = post.description
        postImageView.image = UIImage(named: post.image)
//        postImageView.sizeToFit()
        likesLabel.text = "Likes: \(post.likes)"
        viewsLabel.text = "Views: \(post.views)"
    }
}
