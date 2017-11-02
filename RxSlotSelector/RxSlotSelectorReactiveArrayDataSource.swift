//
//  Rxfzf.swift
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
  
  public struct SlotModel {
    
    let title: String
    let items: [String]
    
    public init(title: String, items: [String]) {
      
      self.title = title
      self.items = items
    }
  }
  
  class RxSlotSelectorDataSource : NSObject, SectionedViewDataSourceType, RxSlotSelectorDataSourceType {
    
    override init() {
      super.init()
    }
    
    var itemModels: [SlotModel]? = nil
    
    func slotSelector(_ slotSelector: SlotSelectorController, observedEvent: Event<[SlotModel]>) {
      Binder(self) { slotSelectorDataSource, sectionModels in
        slotSelectorDataSource.slotSelector(slotSelector, observedElements: sectionModels)
        }.on(observedEvent)
    }
    
    
    func model(at indexPath: IndexPath) throws -> Any {
      precondition(indexPath.section == 0)
      guard let item = itemModels?[indexPath.item] else {
        throw RxCocoaError.itemsNotYetBound(object: self)
      }
      return item
    }
    
    func slotSelector(_ slotSelector: SlotSelectorController, observedElements: [SlotModel]) {
      self.itemModels = observedElements
      slotSelector.reloadData()
    }
    
    func numberOfElements(forSelector selector: SlotSelectorController) -> Int {
      return itemModels?.count ?? 0
    }
    
    func elementValue(forSelector selector: SlotSelectorController, atElementIndex elementIndex: Int) -> String {
      return itemModels?[elementIndex].title ?? ""
    }
    
    func numberOfSlots(forSelector selector: SlotSelectorController, atElementIndex elementIndex: Int) -> Int {
      return itemModels?[elementIndex].items.count ?? 0
    }
    
    func slotValue(forSelector selector: SlotSelectorController, atElementIndex elementIndex: Int, andSlotIndex slotIndex: Int) -> String {
      return itemModels?[elementIndex].items[slotIndex] ?? ""
    }
  }
  
#endif

