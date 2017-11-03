//
//  RxSlotSelectorDelegateProxy.swift
//  RxSlotSelector
//
//  Created by Xavier De Koninck on 03/11/2017.
//  Copyright © 2017 Xavier De Koninck. All rights reserved.
//


#if os(iOS) || os(tvOS)
  
  import UIKit
  import SlotSelector
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
#endif
  
  /// For more information take a look at `DelegateProxyType`.
  open class RxSlotSelectorDelegateProxy: DelegateProxy<SlotSelectorController, SlotSelectorDelegate>, DelegateProxyType, SlotSelectorDelegate {
    
    public static func currentDelegate(for object: SlotSelectorController) -> SlotSelectorDelegate? {
      return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: SlotSelectorDelegate?, to object: SlotSelectorController) {
      object.delegate = delegate
    }
    
    
    /// Typed parent object.
    public weak private(set) var slotSelector: SlotSelectorController?
    
    public init(slotSelector: SlotSelectorController) {
      self.slotSelector = slotSelector
      super.init(parentObject: slotSelector, delegateProxy: RxSlotSelectorDelegateProxy.self)
    }
    
    // Register known implementations
    public static func registerKnownImplementations() {
      self.register { RxSlotSelectorDelegateProxy(slotSelector: $0) }
     }
  }
  
#endif
