//
//  RxSlotSelectorDataSourceType.swift
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
    
  public protocol RxSlotSelectorDataSourceType : SlotSelectorDataSource {
    func slotSelector(_ slotSelector: SlotSelectorController, observedEvent: Event<[SlotModel]>) -> Void
  }
  
#endif
