/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import UIKit

internal class SlotReloadCell: UICollectionViewCell, SlotCellConfigurable {
  
  var configuration: SlotConfiguration?
  
  fileprivate let reloadImageView: UIImageView
  
  var elementIndex: Int?
  weak var selector: SlotSelectorController?
  
  override init(frame: CGRect) {
    
    reloadImageView = UIImageView()
    
    super.init(frame: frame)
    
    setupViews()
  }


  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
  fileprivate func setupViews() {
    
    addSubview(reloadImageView)
    
    reloadImageView.translatesAutoresizingMaskIntoConstraints                 = false
    reloadImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    reloadImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }


  func setup() {
    
    guard let configuration = configuration else { return }
    
    backgroundColor = configuration.reloadElement.backgroundColor

    reloadImageView.widthAnchor.constraint(equalToConstant: configuration.reloadElement.imageWidth).isActive   = true
    reloadImageView.heightAnchor.constraint(equalToConstant: configuration.reloadElement.imageHeight).isActive = true
    reloadImageView.image = UIImage(named: configuration.reloadElement.imageName)
  }
}
