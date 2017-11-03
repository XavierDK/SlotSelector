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
import RxDataSources
import RxSlotSelector
import SlotSelector

class ViewController: UIViewController {
  
  let slotSelectorController = SlotSelectorController()
  //  let dataSource = RxSlotSelectorSectionedReloadDataSource<SectionModel<String, String>>()
  
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(slotSelectorController.view)
    
    slotSelectorController.view.translatesAutoresizingMaskIntoConstraints = false
    slotSelectorController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    slotSelectorController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    slotSelectorController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    slotSelectorController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
    slotSelectorController.rx.slotSelected
      .distinctUntilChanged()
      .subscribe(onNext:{ print("Slot selectecx \($0)") })
      .disposed(by: disposeBag)
    
    slotSelectorController.rx.elementSelected
      .distinctUntilChanged()
      .subscribe(onNext:{ print("Element selected \($0)") })
      .disposed(by: disposeBag)
    
    Observable.just([SlotModel(title: "RGEGE", items: ["1", "2", "3"]),
                     SlotModel(title: "RGEGE2", items: ["4", "5", "6"]),
                     SlotModel(title: "RGEGE3", items: [])])
      .bind(to: slotSelectorController.rx.items)
      .disposed(by: disposeBag)
  }
}

