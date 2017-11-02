/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.sxzszs
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import UIKit

internal class SlotSelectedElementCell: UICollectionViewCell, SlotCellConfigurable, SlotCellValuable {
  
  var elementIndex: Int?
  
  var value: String?
  var configuration: SlotConfiguration?
  
  weak var selector: SlotSelectorController?
  
  fileprivate let titleLabel: UILabel
  
  override init(frame: CGRect) {
    
    titleLabel = UILabel()
    
    super.init(frame: frame)
    
    addSubview(titleLabel)
    
    titleLabel.textAlignment = .center
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.leadingAnchor.constraint(
      equalTo: leadingAnchor).isActive   = true
    titleLabel.trailingAnchor.constraint(
      equalTo: trailingAnchor).isActive  = true
    titleLabel.topAnchor.constraint(
      equalTo: topAnchor).isActive       = true
    titleLabel.bottomAnchor.constraint(
      equalTo: bottomAnchor).isActive    = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
 
  override func prepareForReuse() {
    
    super.prepareForReuse()    
  }
  
  func setup() {
    
    guard let configuration = configuration else { return }
   
    backgroundColor = configuration.element.backgroundColor
    
    titleLabel.text       = value
    titleLabel.font       = configuration.element.font
    titleLabel.textColor  = configuration.element.textColor
  }
  
  func select() {}
}
