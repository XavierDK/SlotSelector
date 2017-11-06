/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

@objc public protocol SlotSelectorDataSource: NSObjectProtocol {
  
  func numberOfElements(forSelector selector: SlotSelectorController) -> Int
  func elementValue(forSelector selector: SlotSelectorController, atElementIndex elementIndex: Int) -> String
  func numberOfSlots(forSelector selector: SlotSelectorController, atElementIndex elementIndex: Int) -> Int
  func slotValue(forSelector selector: SlotSelectorController, atElementIndex elementIndex: Int, andSlotIndex slotIndex: Int) -> String
  
  @objc optional func previousElementNotEmpty(fromElementIndex elementIndex: Int) -> Int
  @objc optional func previousValueNotEmpty(fromElementIndex elementIndex: Int) -> String?
  @objc optional func nextElementNotEmpty(fromElementIndex elementIndex: Int) -> Int
  @objc optional func nextValueNotEmpty(fromElementIndex elementIndex: Int) -> String?
}


@objc public protocol SlotSelectorDelegate: NSObjectProtocol {

  @objc optional func elementSelected(forElementIndex elementIndex: Int)
  @objc optional func slotSelected(forElementIndex elementIndex: Int, andSlotIndex slotIndex: Int)
  @objc optional func errorWhenLoadingDates(from elementIndex: Int)
  
  @objc optional func previousAvailableElementClicked()
  @objc optional func nextAvailableElementClicked()

  @objc optional func previousElementClicked()
  @objc optional func nextElementClicked()
}


@objc open class SlotIndexPath: NSObject {
  
  var elementIndex: Int
  var slotIndex: Int
  
  init(elementIndex: Int, slotIndex: Int) {
    
    self.elementIndex = elementIndex
    self.slotIndex    = slotIndex
  }
}

@objc open class SlotSelectorController: UIViewController {
  
  fileprivate let flowLayout: UICollectionViewFlowLayout
  fileprivate let collectionView: UICollectionView
  
  fileprivate let previousButton: UIButton
  fileprivate let nextButton: UIButton
  
  var selectedElement: SlotIndexPath? {
    
    didSet {
      
      if let selectedElement = self.selectedElement {
        self.collectionView.scrollToItem(at: IndexPath(row: selectedElement.elementIndex * 2, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        return
      }
      self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
    }
  }
  
  public weak var dataSource: SlotSelectorDataSource? {
    didSet {
      
      nextButton.isEnabled      = hasNext()
      previousButton.isEnabled  = hasPrevious()
    }
  }
  
  public weak var delegate: SlotSelectorDelegate?
  
  public var hasError: Bool = false {
    didSet {
      collectionView.reloadData()
    }
  }
  
  public fileprivate(set) var configuration: SlotConfiguration
  
  fileprivate let selectedElementCellIdentifier = "SelectedElementCell"
  fileprivate let slotCollectionCellIdentifier  = "SlotCollectionCell"
  fileprivate let slotReloadCellIdentifier      = "SlotReloadCell"
  
  fileprivate var elementIndex: Int = 0


  public convenience init() {
    
    self.init(nibName: nil, bundle: nil)
  }


  public convenience init(withConfiguration configuration: SlotConfiguration) {
    
    self.init(nibName: nil, bundle: nil)
    self.configuration = configuration
  }


  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    
    configuration   = SlotConfiguration.defaultConfiguration
    
    flowLayout      = UICollectionViewFlowLayout()
    collectionView  = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    
    previousButton  = UIButton(type: .custom)
    nextButton      = UIButton(type: .custom)
    
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }


  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  override open func viewDidLoad() {
  
    super.viewDidLoad()
    
    setup()
  }


  override open func viewDidAppear(_ animated: Bool) {
    
    super.viewDidAppear(animated)        
    
    delegate?.elementSelected?(forElementIndex: elementIndex)
  }


  override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    
    super.viewWillTransition(to: size, with: coordinator)
    
    guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
      return
    }
    flowLayout.invalidateLayout()
  }


  fileprivate func setup() {
    
    flowLayout.minimumLineSpacing       = 0
    flowLayout.minimumInteritemSpacing  = 0
    flowLayout.scrollDirection          = .horizontal
    
    collectionView.dataSource = self
    collectionView.delegate   = self
    view.addSubview(collectionView)
    
    collectionView.bounces                        = false
    collectionView.isPagingEnabled                = true
    collectionView.showsHorizontalScrollIndicator = false
    
    collectionView.register(SlotSelectedElementCell.self, forCellWithReuseIdentifier: selectedElementCellIdentifier)
    collectionView.register(SlotCollectionCell.self, forCellWithReuseIdentifier: slotCollectionCellIdentifier)
    collectionView.register(SlotReloadCell.self, forCellWithReuseIdentifier: slotReloadCellIdentifier)
    
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive   = true
    collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive           = true
    collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive     = true
    
    setupButtons()
  }


  fileprivate func setupButtons() {
    
    view.addSubview(previousButton)
    view.addSubview(nextButton)
    
    previousButton.addTarget(self, action: #selector(goToPrevious), for: .touchDown)
    nextButton.addTarget(self, action: #selector(goToNext), for: .touchDown)
    
    previousButton.setImage(UIImage(named: configuration.buttons.previousEnabledImage), for: .normal)
    nextButton.setImage(UIImage(named: configuration.buttons.nextEnabledImage), for: .normal)
    
    previousButton.setImage(UIImage(named: configuration.buttons.previousDisabledImage), for: .disabled)
    nextButton.setImage(UIImage(named: configuration.buttons.nextDisabledImage), for: .disabled)
    
    previousButton.translatesAutoresizingMaskIntoConstraints = false
    previousButton.widthAnchor.constraint(equalToConstant: configuration.buttons.previousSize.width).isActive = true
    previousButton.heightAnchor.constraint(equalToConstant: configuration.buttons.previousSize.height).isActive = true
    previousButton.topAnchor.constraint(equalTo: view.topAnchor, constant: (configuration.element.height - configuration.buttons.previousSize.height) / 2).isActive = true
    previousButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: configuration.buttons.margin).isActive   = true
    
    nextButton.translatesAutoresizingMaskIntoConstraints = false
    nextButton.widthAnchor.constraint(equalToConstant: configuration.buttons.nextSize.width).isActive = true
    nextButton.heightAnchor.constraint(equalToConstant: configuration.buttons.nextSize.height).isActive = true
    nextButton.topAnchor.constraint(equalTo: view.topAnchor, constant: (configuration.element.height - configuration.buttons.nextSize.height) / 2).isActive = true
    nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -configuration.buttons.margin).isActive   = true
    
    nextButton.isEnabled      = hasNext()
    previousButton.isEnabled  = hasPrevious()
  }


  public func reloadData() {
    
    nextButton.isEnabled      = hasNext()
    nextButton.accessibilityIdentifier = AccessibilitySlotSelector.nextButton.id
    nextButton.accessibilityLabel = AccessibilitySlotSelector.nextButton.label

    previousButton.isEnabled  = hasPrevious()
    previousButton.accessibilityIdentifier = AccessibilitySlotSelector.previousButton.id
    previousButton.accessibilityLabel = AccessibilitySlotSelector.previousButton.label

    collectionView.reloadData()
  }


  public func hasPrevious() -> Bool {
    
    return has(elementIndex: elementIndex - 1)
  }


  public func hasNext() -> Bool {
    
    return has(elementIndex: elementIndex + 1)
  }


  public func has(elementIndex: Int) -> Bool {

    var numberOfElements = dataSource?.numberOfElements(forSelector: self) ?? 0

    if hasError { numberOfElements = numberOfElements + 1 }

    guard numberOfElements >= 0 else { return false }

    return elementIndex >= 0 && elementIndex < numberOfElements
  }

  
  @objc public func goToPrevious() {
    
    goTo(elementIndex: elementIndex - 1)
    delegate?.previousElementClicked?()
  }


  @objc public func goToNext() {

    goTo(elementIndex: elementIndex + 1)
    delegate?.nextElementClicked?()
  }


  public func goTo(elementIndex: Int) {
    
    if has(elementIndex: elementIndex) {
      collectionView.setContentOffset(CGPoint(x: collectionView.frame.width * CGFloat(elementIndex), y: 0), animated: true)
    }
  }

  enum AccessibilitySlotSelector {
    case previousButton
    case nextButton
    var id : String {
      switch self {
      case .previousButton:
        return "accessID_slotSelector_previousButton"
      case .nextButton:
        return "accessID_slotSelector_nextButton"
      }
    }

    var label : String {

      switch self {
      case .previousButton:
        return NSLocalizedString("accessLABEL_slotSelector_previousButton", comment: "")
      case .nextButton:
        return NSLocalizedString("accessLABEL_slotSelector_nextButton", comment: "")
      }
    }
  }
}


extension SlotSelectorController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return (dataSource?.numberOfElements(forSelector: self) ?? 0) * 2 + ((hasError) ? (1) : (0))
  }


  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell: UICollectionViewCell
    
    if indexPath.row == (dataSource?.numberOfElements(forSelector: self) ?? 0) * 2 {
      
      cell = collectionView.dequeueReusableCell(withReuseIdentifier: slotReloadCellIdentifier, for: indexPath)
    }
    else if indexPath.row % 2 == 0 {
      
      cell = collectionView.dequeueReusableCell(withReuseIdentifier: selectedElementCellIdentifier, for: indexPath)
    }
    else {
      
      cell = collectionView.dequeueReusableCell(withReuseIdentifier: slotCollectionCellIdentifier, for: indexPath)
      
      if let cell = cell as? SlotCollectionCell {
        
        cell.dataSource     = dataSource
        cell.delegate       = delegate
        cell.selector       = self
        cell.elementIndex   = indexPath.row / 2
      }
    }
    
    if let cell = cell as? SlotCellValuable {
      
      cell.value = dataSource?.elementValue(forSelector: self, atElementIndex: indexPath.row / 2)
    }
    
    if let cell = cell as? SlotCellConfigurable {
      
      cell.configuration  = configuration
      cell.setup()
    }
    
    return cell
  }


  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if indexPath.row == (dataSource?.numberOfElements(forSelector: self) ?? 0) * 2 {
      return collectionView.frame.size
    }
    
    return (indexPath.row % 2 == 0)
      ? (CGSize(width: collectionView.frame.width, height: configuration.element.height))
      : (CGSize(width: collectionView.frame.width, height: collectionView.frame.height - configuration.element.height))
  }


  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    // si on click sur une cellule de page de dispos en erreur, on relance la requete !
    if let _ = collectionView.cellForItem(at: indexPath) as? SlotReloadCell {
      delegate?.errorWhenLoadingDates?(from: elementIndex)
    }
  }


  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let newElementIndex = Int(scrollView.contentOffset.x / view.frame.width)
    
    if newElementIndex != elementIndex {
      
      if newElementIndex > elementIndex {
        delegate?.nextElementClicked?()
      }
      else {
        delegate?.previousElementClicked?()
      }
      
      elementIndex = newElementIndex
      nextButton.isEnabled = hasNext()
      previousButton.isEnabled = hasPrevious()
      delegate?.elementSelected?(forElementIndex: elementIndex)
    }
  }
}
