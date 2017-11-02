//
//  ViewController.swift
//  Demo
//
//  Created by Xavier De Koninck on 02/11/2017.
//  Copyright © 2017 Xavier De Koninck. All rights reserved.
//

import UIKit
import SlotSelector
import RxSlotSelector

class ViewController: UIViewController {
  
  let slotSelectorController = SlotSelectorController()

  override func viewDidLoad() {
    super.viewDidLoad()

    slotSelectorController.dataSource = self
    slotSelectorController.delegate   = self
    
    view.addSubview(slotSelectorController.view)
    
    slotSelectorController.view.translatesAutoresizingMaskIntoConstraints = false
    slotSelectorController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    slotSelectorController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    slotSelectorController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    slotSelectorController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }
}

extension ViewController: SlotSelectorDataSource, SlotSelectorDelegate {
  
  func numberOfElements(forSelector selector: SlotSelectorController) -> Int {
    
    return 8
  }
  
  
  func elementValue(forSelector selector: SlotSelectorController, atElementIndex elementIndex: Int) -> String {
    
    return "Test"
  }
  
  
  func numberOfSlots(forSelector selector: SlotSelectorController, atElementIndex elementIndex: Int) -> Int {
    
    return 20
  }
  
  
  func slotValue(forSelector selector: SlotSelectorController, atElementIndex elementIndex: Int, andSlotIndex slotIndex: Int) -> String {
    
    return "Test"
  }
}
