//
//  RxSlotSelector.swift
//  RxSlotSelector
//
//  Created by Xavier De Koninck on 02/11/2017.
//  Copyright © 2017 Xavier De Koninck. All rights reserved.
//

#if os(iOS) || os(tvOS)
  
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
#endif
  import UIKit
  import SlotSelector
  
  public extension Reactive where Base: SlotSelectorController {
    
    public func items(_ source: Observable<[SlotModel]>) -> Disposable {
      let dataSource = RxSlotSelectorDataSource()
      return self.items(dataSource: dataSource)(source)
    }

    public func items< DataSource: RxSlotSelectorDataSourceType & SlotSelectorDataSource> (dataSource: DataSource) -> (_ source: Observable<[SlotModel]>) -> Disposable {
        return { source in
          
          // Strong reference is needed because data source is in use until result subscription is disposed
          return source.subscribeProxyDataSource(ofObject: self.base, dataSource: dataSource as SlotSelectorDataSource, retainDataSource: true) { [weak slotSelector = self.base] (_: RxSlotSelectorDataSourceProxy, event) -> Void in
            guard let slotSelector = slotSelector else {
              return
            }
            dataSource.slotSelector(slotSelector, observedEvent: event)
          }
        }
    }
  }
  
  extension Reactive where Base: SlotSelectorController {
    
    /**
     Reactive wrapper for `dataSource`.
     
     For more information take a look at `DelegateProxyType` protocol documentation.
     */
    public var dataSource: DelegateProxy<SlotSelectorController, SlotSelectorDataSource> {
      return RxSlotSelectorDataSourceProxy.proxy(for: base)
    }
    
    /**
     Installs data source as forwarding delegate on `rx.dataSource`.
     Data source won't be retained.
     
     It enables using normal delegate mechanism with reactive delegate mechanism.
     
     - parameter dataSource: Data source object.
     - returns: Disposable object that can be used to unbind the data source.
     */
    public func setDataSource(_ dataSource: SlotSelectorDataSource) -> Disposable {
      return RxSlotSelectorDataSourceProxy.installForwardDelegate(dataSource, retainDelegate: false, onProxyForObject: self.base)
    }
    
    /**
     Synchronous helper method for retrieving a model at indexPath through a reactive data source.
     */
    public func model<T>(at indexPath: IndexPath) throws -> T {
      let dataSource: SectionedViewDataSourceType = castOrFatalError(self.dataSource.forwardToDelegate(), message: "This method only works in case one of the `rx.items*` methods was used.")
      
      let element = try dataSource.model(at: indexPath)
      
      return castOrFatalError(element)
    }
  }
  
  func castOrFatalError<T>(_ value: AnyObject!, message: String) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
      fatalError(message)
    }
    
    return result
  }
  
  func castOrFatalError<T>(_ value: Any!) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
      fatalError("Failure converting from \(value) to \(T.self)")
    }
    
    return result
  }
  
  func bindingError(_ error: Swift.Error) {
    let error = "Binding error: \(error)"
    #if DEBUG
      fatalError(error)
    #else
      print(error)
    #endif
  }
  
#if os(iOS) || os(tvOS)
  import UIKit
  
  extension ObservableType {
    
    func subscribeProxyDataSource<DelegateProxy: DelegateProxyType>(ofObject object: DelegateProxy.ParentObject, dataSource: DelegateProxy.Delegate, retainDataSource: Bool, binding: @escaping (DelegateProxy, Event<E>) -> Void) -> Disposable
      where DelegateProxy.ParentObject: UIViewController {
        
        let proxy = DelegateProxy.proxy(for: object)
        let unregisterDelegate = DelegateProxy.installForwardDelegate(dataSource, retainDelegate: retainDataSource, onProxyForObject: object)
        // this is needed to flush any delayed old state (https://github.com/RxSwiftCommunity/RxDataSources/pull/75)
        object.view.layoutIfNeeded()
        
        let subscription = self.asObservable()
          .observeOn(MainScheduler())
          .catchError { error in
            bindingError(error)
            return Observable.empty()
          }
          // source can never end, otherwise it would release the subscriber, and deallocate the data source
          .concat(Observable.never())
          .takeUntil(object.rx.deallocated)
          .subscribe { [weak object] (event: Event<E>) in
            
            if let object = object {
              assert(proxy === DelegateProxy.currentDelegate(for: object), "Proxy changed from the time it was first set.\nOriginal: \(proxy)\nExisting: \(String(describing: DelegateProxy.currentDelegate(for: object)))")
            }
            
            binding(proxy, event)
            
            switch event {
            case .error(let error):
              bindingError(error)
              unregisterDelegate.dispose()
            case .completed:
              unregisterDelegate.dispose()
            default:
              break
            }
        }
        
        return Disposables.create { [weak object] in
          subscription.dispose()
          object?.view.layoutIfNeeded()
          unregisterDelegate.dispose()
        }
    }
  }
  
#endif
  
#endif
