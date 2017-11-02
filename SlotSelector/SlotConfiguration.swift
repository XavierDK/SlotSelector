/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import UIKit

public struct SlotConfiguration {
  
  let element: Element
  let emptyElement: EmptyElement
  let reloadElement: ReloadElement
  let slotsCollection: SlotsCollection
  let slot: Slot
  let buttons: Buttons
  
  public static var defaultConfiguration: SlotConfiguration {
    return SlotConfiguration(element: Element.defaultConfiguration, emptyElement: SlotConfiguration.EmptyElement.defaultConfiguration, reloadElement: SlotConfiguration.ReloadElement.defaultConfiguration, slotsCollection: SlotsCollection.defaultConfiguration, slot: Slot.defaultConfiguration, buttons: Buttons.defaultConfiguration)
  }
}

extension SlotConfiguration {

  public struct Element {
    
    let height: CGFloat
    let font: UIFont
    let textColor: UIColor
    let backgroundColor: UIColor
    
    public static var defaultConfiguration: Element {
      return Element(height: 80, font: UIFont.systemFont(ofSize: 18), textColor: UIColor.black, backgroundColor: UIColor.white)
    }
  }
}

extension SlotConfiguration {
  
  public struct EmptyElement {
    
    let titleFont: UIFont
    let labelsFont: UIFont
    let buttonsFont: UIFont
    let titleTextColor: UIColor
    let labelsTextColor: UIColor
    let buttonsTextColor: UIColor
    let buttonsCornerRadius: CGFloat
    let backgroundColor: UIColor
    let buttonsBackgroundColor: UIColor
    let titleLabel: String
    let previousLabel: String
    let nextLabel: String
    
    public static var defaultConfiguration: EmptyElement {
      return EmptyElement(titleFont: UIFont.systemFont(ofSize: 15), labelsFont: UIFont.systemFont(ofSize: 15), buttonsFont: UIFont.boldSystemFont(ofSize: 17), titleTextColor: UIColor.black, labelsTextColor: UIColor.black, buttonsTextColor: UIColor.black, buttonsCornerRadius: 2.0, backgroundColor: UIColor.white, buttonsBackgroundColor: UIColor.blue, titleLabel: "No slot", previousLabel: "Previous", nextLabel: "Next")
    }
  }
}

extension SlotConfiguration {
  
  public struct ReloadElement {
    
    let imageWidth: CGFloat
    let imageHeight: CGFloat
    let imageName: String
    let backgroundColor: UIColor
    
    public static var defaultConfiguration: ReloadElement {
      return ReloadElement(imageWidth: 0, imageHeight: 0, imageName: "", backgroundColor: UIColor.white)
    }
  }
}

extension SlotConfiguration {
  
  public struct SlotsCollection {
    
    let sectionInsets: UIEdgeInsets
    let nbElementsPerLine: Int
    let minMarginBetweenSlots: CGFloat
    let backgroundColor: UIColor
    
    public static var defaultConfiguration: SlotsCollection {
      return SlotsCollection(sectionInsets: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30), nbElementsPerLine: 3, minMarginBetweenSlots: 10, backgroundColor: UIColor.white)
    }
  }
}

extension SlotConfiguration {
  
  public struct Slot {
    
    let height: CGFloat
    let font: UIFont
    let textColor: UIColor
    let textColorSelected: UIColor
    let backgroundColor: UIColor
    let backgroundColorSelected: UIColor
    let cornerRadius: CGFloat
    
    public static var defaultConfiguration: Slot {
      return Slot(height: 50, font: UIFont.systemFont(ofSize: 18), textColor: UIColor.black, textColorSelected: UIColor.white, backgroundColor: UIColor.cyan, backgroundColorSelected: UIColor.yellow, cornerRadius: 2.0)
    }
  }
}

extension SlotConfiguration {
  
  public struct Buttons {
    
    let margin: CGFloat
    
    let previousSize: CGSize
    let previousEnabledImage: String
    let previousDisabledImage: String
    
    let nextSize: CGSize
    let nextEnabledImage: String
    let nextDisabledImage: String
    
    public static var defaultConfiguration: Buttons {
      return Buttons(margin: 30, previousSize: CGSize(width: 50, height: 50), previousEnabledImage: "PreviousEnabledButton", previousDisabledImage: "PreviousDisabledButton", nextSize: CGSize(width: 50, height: 50), nextEnabledImage: "NextEnabledButton", nextDisabledImage: "NextDisabledButton")
    }
  }
}
