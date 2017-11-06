//
//  RxSlotSelectorDataSourceProxy.swift
//  RxSlotSelector
//
//  Created by Xavier De Koninck on 02/11/2017.
//  Copyright © 2017 Xavier De Koninck. All rights reserved.
//

#if os(iOS) || os(tvOS)
  
  import UIKit
  import SlotSelector
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
#endif
  
  extension SlotSelectorController: HasDataSource {
    public typealias DataSource = SlotSelectorDataSource
  }
  
let slotSelectorDataSourceNotSet = SlotSelectorDataSourceNotSet()
  
  final class SlotSelectorDataSourceNotSet
    : NSObject
  , SlotSelectorDataSource {
    
    func numberOfElements(forSelector selector: SlotSelectorController) -> Int {
      return 0
    }
    
    func elementValue(forSelector selector: SlotSelectorController, atElementIndex elementIndex: Int) -> String {
      return ""
    }
    
    func numberOfSlots(forSelector selector: SlotSelectorController, atElementIndex elementIndex: Int) -> Int {
      return 0
    }
    
    func slotValue(forSelector selector: SlotSelectorController, atElementIndex elementIndex: Int, andSlotIndex slotIndex: Int) -> String {
      return ""
    }
  }
  
  /// For more information take a look at `DelegateProxyType`.
  open class RxSlotSelectorDataSourceProxy
    : DelegateProxy<SlotSelectorController, SlotSelectorDataSource>
    , DelegateProxyType
  , SlotSelectorDataSource {
    
    /// Typed parent object.
    public weak private(set) var slotSelector: SlotSelectorController?
    
    /// - parameter tableView: Parent object for delegate proxy.
    public init(slotSelector: SlotSelectorController) {
      self.slotSelector = slotSelector
      super.init(parentObject: slotSelector, delegateProxy: RxSlotSelectorDataSourceProxy.self)
    }
    
    // Register known implementations
    public static func registerKnownImplementations() {
      self.register { RxSlotSelectorDataSourceProxy(slotSelector: $0) }
    }
    
    fileprivate weak var _requiredMethodsDataSource: SlotSelectorDataSource? = slotSelectorDataSourceNotSet
    
    // MARK: delegate
    
    
    public func numberOfElements(forSelector selector: SlotSelectorController) -> Int {
      return (_requiredMethodsDataSource ?? slotSelectorDataSourceNotSet).numberOfElements(forSelector: selector)
    }
    
    public func elementValue(forSelector selector: SlotSelectorController, atElementIndex elementIndex: Int) -> String {
      return (_requiredMethodsDataSource ?? slotSelectorDataSourceNotSet).elementValue(forSelector: selector, atElementIndex: elementIndex)
    }
    
    public func numberOfSlots(forSelector selector: SlotSelectorController, atElementIndex elementIndex: Int) -> Int {
      return (_requiredMethodsDataSource ?? slotSelectorDataSourceNotSet).numberOfSlots(forSelector: selector, atElementIndex: elementIndex)
    }
    
    public func slotValue(forSelector selector: SlotSelectorController, atElementIndex elementIndex: Int, andSlotIndex slotIndex: Int) -> String {
      return (_requiredMethodsDataSource ?? slotSelectorDataSourceNotSet).slotValue(forSelector: selector, atElementIndex: elementIndex, andSlotIndex: slotIndex)
    }
    
    public func previousElementNotEmpty(fromElementIndex elementIndex: Int) -> Int {
      return (_requiredMethodsDataSource ?? slotSelectorDataSourceNotSet).previousElementNotEmpty?(fromElementIndex: elementIndex) ?? -1
    }
    
    public func previousValueNotEmpty(fromElementIndex elementIndex: Int) -> String? {
      return (_requiredMethodsDataSource ?? slotSelectorDataSourceNotSet).previousValueNotEmpty?(fromElementIndex: elementIndex)
    }
    
    public func nextElementNotEmpty(fromElementIndex elementIndex: Int) -> Int {
      return (_requiredMethodsDataSource ?? slotSelectorDataSourceNotSet).nextElementNotEmpty?(fromElementIndex: elementIndex) ?? -1
    }
    
    public  func nextValueNotEmpty(fromElementIndex elementIndex: Int) -> String? {
      return (_requiredMethodsDataSource ?? slotSelectorDataSourceNotSet).nextValueNotEmpty?(fromElementIndex: elementIndex)
    }

    
    /// For more information take a look at `DelegateProxyType`.
    open override func setForwardToDelegate(_ forwardToDelegate: SlotSelectorDataSource?, retainDelegate: Bool) {
      _requiredMethodsDataSource = forwardToDelegate  ?? slotSelectorDataSourceNotSet
      super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
    }
  
  }
  
#endif
