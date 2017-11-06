/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import UIKit

internal class SlotEmptyCell: UICollectionViewCell, SlotCellConfigurable {
  
  var configuration: SlotConfiguration?
  
  fileprivate let titleLabel: UILabel
  fileprivate let previousLabel: UILabel
  fileprivate let nextLabel: UILabel
  fileprivate let previousButton: UIButton
  fileprivate let nextButton: UIButton
  
  fileprivate let firstVerticaleStackView: UIStackView
  fileprivate let secondVerticaleStackView: UIStackView
  
  var elementIndex: Int?
  weak var selector: SlotSelectorController?
  
  override init(frame: CGRect) {
    
    titleLabel      = UILabel()
    previousLabel   = UILabel()
    nextLabel       = UILabel()
    previousButton  = UIButton(type: .custom)
    nextButton      = UIButton(type: .custom)
    
    firstVerticaleStackView   = UIStackView(arrangedSubviews: [previousLabel, previousButton])
    secondVerticaleStackView  = UIStackView(arrangedSubviews: [nextLabel, nextButton])
    
    super.init(frame: frame)
    
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    
    super.prepareForReuse()
  }
  
  fileprivate func setupViews() {
   
    addSubview(titleLabel)
    
    let horizontaleStackView  = UIStackView(arrangedSubviews: [firstVerticaleStackView, secondVerticaleStackView])
    
    addSubview(horizontaleStackView)
    
    titleLabel.textAlignment = .center
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: horizontaleStackView.topAnchor, constant: -30).isActive = true
    
    titleLabel.textAlignment = .center
    previousLabel.textAlignment = .center
    nextLabel.textAlignment = .center
    
    
    previousButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    firstVerticaleStackView.axis  = .vertical
    secondVerticaleStackView.axis = .vertical
    horizontaleStackView.axis     = .horizontal
    
    firstVerticaleStackView.spacing   = 10
    secondVerticaleStackView.spacing  = 10
    
    horizontaleStackView.distribution = .fillEqually
    horizontaleStackView.alignment    = .center
    horizontaleStackView.spacing      = 10
    
    horizontaleStackView.translatesAutoresizingMaskIntoConstraints = false
    horizontaleStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    horizontaleStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    horizontaleStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
    
    previousButton.addTarget(self, action: #selector(self.previousPressed), for: .touchDown)
    nextButton.addTarget(self, action: #selector(self.nextPressed), for: .touchDown)
  }
  
  func setup() {
    
    guard let configuration = configuration else { return }
    
    titleLabel.text                     = configuration.emptyElement.titleLabel
    previousLabel.text                  = configuration.emptyElement.previousLabel
    nextLabel.text                      = configuration.emptyElement.nextLabel
    
    backgroundColor                     = configuration.emptyElement.backgroundColor
    
    titleLabel.font                     = configuration.emptyElement.titleFont
    titleLabel.textColor                = configuration.emptyElement.titleTextColor
    
    previousLabel.font                  = configuration.emptyElement.labelsFont
    previousLabel.textColor             = configuration.emptyElement.labelsTextColor
    
    previousButton.titleLabel?.font     = configuration.emptyElement.buttonsFont
    previousButton.backgroundColor      = configuration.emptyElement.buttonsBackgroundColor
    previousButton.layer.masksToBounds  = true
    previousButton.layer.cornerRadius   = configuration.emptyElement.buttonsCornerRadius
    
    nextLabel.font                      = configuration.emptyElement.labelsFont
    nextLabel.textColor                 = configuration.emptyElement.labelsTextColor
    
    nextButton.titleLabel?.font         = configuration.emptyElement.buttonsFont
    nextButton.backgroundColor          = configuration.emptyElement.buttonsBackgroundColor
    nextButton.layer.masksToBounds      = true
    nextButton.layer.cornerRadius       = configuration.emptyElement.buttonsCornerRadius
    
    previousButton.setTitleColor(configuration.emptyElement.buttonsTextColor, for: .normal)
    nextButton.setTitleColor(configuration.emptyElement.buttonsTextColor, for: .normal)
    
    guard let elementIndex = elementIndex else { return }
    
    if let previousValue = selector?.dataSource?.previousValueNotEmpty?(fromElementIndex: elementIndex) {
      firstVerticaleStackView.isHidden = false
      previousButton.setTitle(previousValue, for: .normal)
    }
    else {
      firstVerticaleStackView.isHidden = true
    }
    
    if let nextValue = selector?.dataSource?.nextValueNotEmpty?(fromElementIndex: elementIndex) {
      secondVerticaleStackView.isHidden = false
      nextButton.setTitle(nextValue, for: .normal)
    }
    else {
      secondVerticaleStackView.isHidden = true
    }
  }
  
  @objc func previousPressed() {
    
    guard let elementIndex = elementIndex else { return }
    
    if let previousElement = selector?.dataSource?.previousElementNotEmpty?(fromElementIndex: elementIndex),
      previousElement >= 0 {
      
      selector?.delegate?.previousAvailableElementClicked?()
      
      selector?.goTo(elementIndex: previousElement)
    }
  }
  
  @objc func nextPressed() {
    
    guard let elementIndex = elementIndex else { return }

    if let nextElement = selector?.dataSource?.nextElementNotEmpty?(fromElementIndex: elementIndex),
      nextElement >= 0 {

      selector?.delegate?.nextAvailableElementClicked?()

      selector?.goTo(elementIndex: nextElement)
    }
  }
}
