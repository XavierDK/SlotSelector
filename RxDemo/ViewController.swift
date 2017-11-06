//
//  ViewController.swift
//  RxDemo
//
//  Created by Xavier De Koninck on 02/11/2017.
//  Copyright © 2017 Xavier De Koninck. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSlotSelector
import SlotSelector

class ViewController: UIViewController {
  
  let slotSelectorController = SlotSelectorController()
  
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(slotSelectorController.view)
    
    slotSelectorController.view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      slotSelectorController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      slotSelectorController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      slotSelectorController.view.topAnchor.constraint(equalTo: view.topAnchor),
      slotSelectorController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
    
    slotSelectorController.rx.slotSelected
      .distinctUntilChanged()
      .subscribe(onNext:{ print("Slot selected \($0)") })
      .disposed(by: disposeBag)
    
    slotSelectorController.rx.elementSelected
      .distinctUntilChanged()
      .subscribe(onNext:{ print("Element selected \($0)") })
      .disposed(by: disposeBag)
    
    Observable.just([SlotModel(title: "Test", items: ["1", "2", "3"]),
                     SlotModel(title: "Test2", items: ["4", "5", "6"]),
                     SlotModel(title: "Test3", items: [])])
      .bind(to: slotSelectorController.rx.items) { (timeState, element) in
        
        print(timeState)
        print(element)
        return (1, "Test2")
      }
      .disposed(by: disposeBag)
    
    slotSelectorController.rx.elementClicked.subscribe(onNext: { (timeState) in
      print("ELEMENT CLICKED => \(timeState)")
    })
      .disposed(by: disposeBag)
    
    slotSelectorController.rx.availableElementClicked.subscribe(onNext: { (timeState) in
      print("AVAILABLE ELEMENT CLICKED => \(timeState)")
    })
      .disposed(by: disposeBag)
    
    slotSelectorController.goTo(elementIndex: 2)
  }
}

