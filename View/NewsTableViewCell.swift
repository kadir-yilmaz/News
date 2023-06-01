//
//  NewsTableViewCell.swift
//  News
//
//  Created by Kadir Yılmaz on 25.05.2023.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    static let reusableId = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.backgroundColor = .systemRed
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImageView)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLabel.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width - 170, height: 70)
        
        subtitleLabel.frame = CGRect(x: 10, y: 70, width: contentView.frame.size.width - 170, height: contentView.frame.size.height / 2)
        
        newsImageView.frame = CGRect(x: contentView.frame.size.width - 155, y: 5, width: 150, height: contentView.frame.size.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        newsTitleLabel.text = nil
        subtitleLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL{
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                viewModel.imageData = data
                
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }

}
