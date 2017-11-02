/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation

internal protocol SlotCellConfigurable: class {
  
  var configuration: SlotConfiguration? { get set }
  
  weak var selector: SlotSelectorController? { get set }
  var elementIndex: Int? { get set }
  
  func setup()
}
