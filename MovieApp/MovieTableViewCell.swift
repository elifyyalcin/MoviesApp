//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by Elif Yalçın on 10.06.2022.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    let movieImg = UIImageView()
    let movieNameLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {
        contentView.addSubview(movieImg)
        contentView.addSubview(movieNameLabel)
        
        movieImg.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
        }
        movieNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(movieImg.snp.centerY)
            make.left.equalTo(movieImg.snp.right).offset(10)
        }
    }
}
