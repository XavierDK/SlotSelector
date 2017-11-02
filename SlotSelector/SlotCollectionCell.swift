/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import UIKit

internal class SlotCollectionCell: UICollectionViewCell, SlotCellConfigurable {
  
  fileprivate let collectionView: UICollectionView
  fileprivate let flowLayout: UICollectionViewFlowLayout
  
  weak var dataSource: SlotSelectorDataSource?
  weak var delegate: SlotSelectorDelegate?
  
  weak var selector: SlotSelectorController?
  var elementIndex: Int?
  var configuration: SlotConfiguration?
  
  fileprivate let slotCellIdentifier        = "SlotCell"
  fileprivate let slotEmptyCellIdentifier   = "SlotEmptyCell"
  
  override init(frame: CGRect) {
    
    flowLayout = UICollectionViewFlowLayout()
    collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    
    super.init(frame: frame)
    
    addSubview(collectionView)
    
    collectionView.register(SlotCell.self, forCellWithReuseIdentifier: slotCellIdentifier)
    collectionView.register(SlotEmptyCell.self, forCellWithReuseIdentifier: slotEmptyCellIdentifier)
    
    collectionView.backgroundColor = configuration?.slotsCollection.backgroundColor
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }


  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  override func prepareForReuse() {
    
    super.prepareForReuse()
    
    collectionView.contentOffset = CGPoint(x: 0, y: 0)
  }


  func setup() {
    
    flowLayout.scrollDirection          = .vertical
    flowLayout.sectionInset             = configuration?.slotsCollection.sectionInsets ?? UIEdgeInsets.zero
    flowLayout.minimumLineSpacing       = configuration?.slotsCollection.minMarginBetweenSlots ?? 0
    flowLayout.minimumInteritemSpacing  = configuration?.slotsCollection.minMarginBetweenSlots ?? 0
    
    collectionView.backgroundColor      = configuration?.slotsCollection.backgroundColor
    collectionView.dataSource           = self
    collectionView.delegate             = self
    collectionView.reloadData()
  }
}


extension SlotCollectionCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    guard let selector = selector, let elementIndex = elementIndex else { return 0 }
    
    let nbSlots = dataSource?.numberOfSlots(forSelector: selector, atElementIndex: elementIndex) ?? 0
    
    return (nbSlots > 0) ? (nbSlots) : (1)
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let selector = selector, let elementIndex = elementIndex else { return UICollectionViewCell() }
    
    let identifier = (dataSource?.numberOfSlots(forSelector: selector, atElementIndex: elementIndex) ?? 0 > 0)
      ? (slotCellIdentifier)
      : (slotEmptyCellIdentifier)
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    
    if let cell = cell as? SlotCellConfigurable {
      
      cell.configuration  = configuration
      cell.selector       = selector
      cell.elementIndex   = elementIndex
      cell.setup()
    }
    
    if let cell = cell as? SlotCellValuable, selector == selector {
      
      cell.value = dataSource?.slotValue(forSelector: selector, atElementIndex: elementIndex, andSlotIndex: indexPath.row)
      
      if selector.selectedElement?.slotIndex == indexPath.row && selector.selectedElement?.elementIndex == elementIndex {
        
        cell.select()
      }
    }
    
    return cell
  }


  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    guard let configuration = configuration, let selector = selector, let elementIndex = elementIndex else { return CGSize.zero }
    
    if (dataSource?.numberOfSlots(forSelector: selector, atElementIndex: elementIndex) ?? 0) == 0 {
      return CGSize(width: collectionView.frame.width - (configuration.slotsCollection.sectionInsets.left + configuration.slotsCollection.sectionInsets.right), height: collectionView.frame.height - (configuration.slotsCollection.sectionInsets.top + configuration.slotsCollection.sectionInsets.bottom))
    }
    
    let minMargin         = configuration.slotsCollection.minMarginBetweenSlots
    let leftMargin        = configuration.slotsCollection.sectionInsets.left
    let rightMargin       = configuration.slotsCollection.sectionInsets.right
    let nbElementsPerLine = CGFloat(configuration.slotsCollection.nbElementsPerLine)
    
    let widthMargin = minMargin * (nbElementsPerLine - 1) + minMargin * 2 + leftMargin + rightMargin
    
    let width   = (collectionView.frame.width - widthMargin) / nbElementsPerLine
    let height  = configuration.slot.height
    
    return CGSize(width: width, height: height)
  }

  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    guard let selector = selector, let elementIndex = elementIndex else { return }
    
    if (dataSource?.numberOfSlots(forSelector: selector, atElementIndex: elementIndex) ?? 0) > 0 {
      
      selector.selectedElement = SlotIndexPath(elementIndex: elementIndex, slotIndex: indexPath.row)
      selector.reloadData()
      
      delegate?.slotSelected?(forElementIndex: elementIndex, andSlotIndex: indexPath.row)
    }
  }
}
