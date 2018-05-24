//
//  ColorBrowser.swift
//  InfiniteScroll
//
//  Created by Allen Ussher on 5/23/18.
//  Copyright © 2018 Ussher Press. All rights reserved.
//

import UIKit

class ColorBrowser: UIView {
    // MAGIC: In this demo, colors acts as the content we want to show in cells,
    // but this could easily be anything.
    var colors: [UIColor] = [] {
        didSet {
            updateCellContents()
        }
    }
    var cellWidth: CGFloat = 20.0 {
        didSet {
            setNeedsLayout()
        }
    }
    // MAGIC: cells is where we display the content in the colors array. If you
    // want to display images, this would be a UIImageView and you'd replace
    // "colors" with an array of images.
    var cells: [UIView]
    let scrollView: UIScrollView
    
    // MAGIC: highlightedColorIndex represented the center item in the viewable
    // region and acts as the "highlighted" item. This code doesn't actually
    // highlight it though, but you could.
    var highlightedColorIndex = 0
    
    // MAGIC: The number of visible cells is always however many can be sceen
    // in the scrollView's visible "view port" + 2. We need to add 2 because
    // we want one cell just off-screen to the left and one just off-screen to
    // the right. When you scroll left and right, they will be exposed. If you
    // scroll too far left, we adjust the contentOffset and update the cell
    // contents. (See scrollViewDidScroll().)
    //
    // TODO: It might be possible to do all this with just the 1 extra cell, but
    // we'd have to be clever about its placement.
    var numVisibleCells: Int {
        return Int(ceil(scrollView.bounds.width / cellWidth)) + 2
    }
    
    override init(frame: CGRect) {
        scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false

        cells = []
        
        super.init(frame: frame)
        
        backgroundColor = .orange
        
        scrollView.delegate = self
        addSubview(scrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MAGIC: Just to be efficient, we call this to ensure we have just
    // enough cells to show on screen, and not one more.
    func ensureCellCount() {
        if cells.count < numVisibleCells {
            let numCellsToAdd = numVisibleCells - cells.count
            for _ in 0..<numCellsToAdd {
                let cell = UIView()
                scrollView.addSubview(cell)
                cells.append(cell)
            }
            updateCellContents()
        } else if cells.count > numVisibleCells {
            while cells.count > numVisibleCells {
                let cell = cells.last!
                cell.removeFromSuperview()
                cells.removeLast()
            }
        }
    }
    
    // MAGIC: Here's where we set the contents of each cell based on which
    // cell is considered the "highlighted" one in the middle.
    func updateCellContents() {
        cells.enumerated().forEach { cellIndex, cell in
            var colorIndex = highlightedColorIndex - (numVisibleCells / 2) + cellIndex
            // These two while loops ensure our colorIndex is within bounds
            // and also causes us to repeat the contents if we can't fit more
            // cells on the screen than we have colors.
            while colorIndex < 0 {
                colorIndex += colors.count
            }
            while colorIndex >= colors.count {
                colorIndex -= colors.count
            }
            
            let color = colors[colorIndex]
            cell.backgroundColor = color
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = self.bounds

        // Whenever our view changes size, we need to ensure we have the right
        // number of cells displayed and that we're showing the correct content.
        ensureCellCount()
        updateCellContents()
        
        scrollView.contentSize = CGSize(width: CGFloat(numVisibleCells) * cellWidth, height: scrollView.bounds.height)
        scrollView.contentOffset = CGPoint(x: cellWidth, y: 0.0)
        
        // Lay out each individual cell.
        for cellIndex in 0..<numVisibleCells {
            let cell = cells[cellIndex]
            cell.frame = CGRect(x: cellWidth * CGFloat(cellIndex), y: 0, width: cellWidth, height: self.bounds.height)
        }
    }
}

extension ColorBrowser: UIScrollViewDelegate {
    // MAGIC: When you scroll contentOffset.x left past the start of the 2nd item
    // (at position x == cellWidth) or you scroll contentOffset.x right past the start
    // of the 3rd item (at position x == 2.0*cellWidth), we re-adjust the contentOffset.x
    // back the other way and then update the contents of the cells. We just shift
    // the contents of each cell over by one.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRegionMinX = cellWidth
        let visibleRegionMaxX = 2.0 * cellWidth
        
        if scrollView.contentOffset.x < visibleRegionMinX {
            // Scroll left
            scrollView.contentOffset.x += cellWidth
            highlightedColorIndex -= 1
            if highlightedColorIndex < 0 {
                highlightedColorIndex += colors.count
            }
            updateCellContents()
        } else if scrollView.contentOffset.x >= visibleRegionMaxX {
            // Scroll right
            scrollView.contentOffset.x -= cellWidth
            highlightedColorIndex += 1
            if highlightedColorIndex >= colors.count {
                highlightedColorIndex -= colors.count
            }
            updateCellContents()
        }
    }
}
