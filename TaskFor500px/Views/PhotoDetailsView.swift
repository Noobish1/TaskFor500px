import Foundation

internal final class PhotoDetailsView: UIView {
    // MARK: properties
    private let detailsContainerView = UIView()
    private lazy var titleLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = .preferredFont(forTextStyle: .title2)
        $0.text = photo.name
    }
    private let subtitleContainerView = UIView()
    private lazy var nameLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.text = "by \(photo.user.fullName)"
    }
    // I made this a separate label so I could increase the fontsize
    // It's simpler than atrributed strings
    private let dotLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = .preferredFont(forTextStyle: .title1)
        $0.text = " · "
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    private lazy var dateLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.text = DateFormatters.relative.localizedString(for: photo.createdAt.date, relativeTo: .now)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    private let avatarImageSize: CGFloat = 40
    private lazy var avatarImageView = UIImageView().then {
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = avatarImageSize / 2
        $0.clipsToBounds = true
        $0.kf.setImage(with: photo.user.avatarURL, placeholder: R.image.defaultAvatar())
    }
    private let photo: Photo
    
    // MARK: init
    internal init(photo: Photo) {
        self.photo = photo
        
        super.init(frame: .zero)
        
        self.backgroundColor = .lightGray
        
        setupViews()
    }
    
    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setup
    private func setupViews() {
        add(
            subview: detailsContainerView,
            withConstraints: { make in
                make.top.equalToSuperview().offset(10)
                make.leading.equalToSuperview().offset(10)
                make.trailing.equalToSuperview().inset(10)
                make.bottom.equalToSuperview().inset(10)
            },
            subviews: { container in
                container.add(subview: titleLabel, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.equalToSuperview()
                })
        
                container.add(
                    subview: subtitleContainerView,
                    withConstraints: { make in
                        make.top.equalTo(titleLabel.snp.bottom)
                        make.leading.equalToSuperview()
                        make.bottom.equalToSuperview()
                    },
                    subviews: { container in
                        container.add(subview: nameLabel, withConstraints: { make in
                            make.top.equalToSuperview()
                            make.leading.equalToSuperview()
                            make.bottom.equalToSuperview()
                        })
                        
                        container.add(subview: dotLabel, withConstraints: { make in
                            make.top.equalToSuperview()
                            make.leading.equalTo(nameLabel.snp.trailing)
                            make.bottom.equalToSuperview()
                        })
                        
                        container.add(subview: dateLabel, withConstraints: { make in
                            make.top.equalToSuperview()
                            make.leading.equalTo(dotLabel.snp.trailing)
                            make.trailing.equalToSuperview()
                            make.bottom.equalToSuperview()
                        })
                    }
                )
                
                container.add(subview: avatarImageView, withConstraints: { make in
                    make.top.greaterThanOrEqualToSuperview()
                    make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(10)
                    make.leading.greaterThanOrEqualTo(subtitleContainerView.snp.trailing).offset(10)
                    make.trailing.equalToSuperview().inset(10)
                    make.bottom.lessThanOrEqualToSuperview()
                    make.centerY.equalToSuperview()
                    make.size.equalTo(avatarImageSize)
                })
            }
        )
    }
}
