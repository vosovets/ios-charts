//
//  GanttChartRenderer.swift
//  Charts
//
//  Created by Vadim Osovets on 1/10/16.
//  Copyright © 2016 dcg. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

public class GanttChartRenderer: BarChartRenderer
{
    /// flag that indicates if this component is enabled or not
    public var valueLabelAnchorCenter = true
    
    public override init(dataProvider: BarChartDataProvider?, animator: ChartAnimator?, viewPortHandler: ChartViewPortHandler)
    {
        super.init(dataProvider: dataProvider, animator: animator, viewPortHandler: viewPortHandler)
    }
    
    private func rectForEntry(context context: CGContext, dataSet: BarChartDataSet, dataEntry: BarChartDataEntry, valueIndex: Int) -> CGRect {
        
        guard let dataProvider = dataProvider, barData = dataProvider.barData else { return CGRectZero}
        
//        CGContextSaveGState(context)
        
        let trans = dataProvider.getTransformer(dataSet.axisDependency)
        
        let drawBarShadowEnabled: Bool = dataProvider.isDrawBarShadowEnabled
        let dataSetOffset = (barData.dataSetCount - 1)
        let groupSpace = barData.groupSpace
        let groupSpaceHalf = groupSpace / 2.0
        let barSpace = dataSet.barSpace
        let barSpaceHalf = barSpace / 2.0
        let containsStacks = dataSet.isStacked
        let isInverted = dataProvider.isInverted(dataSet.axisDependency)
        var entries = dataSet.yVals as! [BarChartDataEntry]
        let barWidth: CGFloat = 0.5
        let phaseY = _animator.phaseY
        var barRect = CGRect()
        var barShadow = CGRect()
        var y: Double
        
        // do the drawing
        for (var j = 0, count = Int(ceil(CGFloat(dataSet.entryCount) * _animator.phaseX)); j < count; j++)
        {
            let e = entries[j]
            
            let ganttData = e.data as? GanttChartData
            
            if (ganttData?.title.characters.count == 0) {
                continue
            }
            
            // calculate the x-position, depending on datasetcount
            let x = CGFloat(e.xIndex + e.xIndex * dataSetOffset) + CGFloat(0)
                + groupSpace * CGFloat(e.xIndex) + groupSpaceHalf
            let values = e.values
            
            if (!containsStacks || values == nil)
            {
                y = e.value
                
                let bottom = x - barWidth + barSpaceHalf
                let top = x + barWidth - barSpaceHalf
                var right = isInverted ? (y <= 0.0 ? CGFloat(y) : 0) : (y >= 0.0 ? CGFloat(y) : 0)
                var left = isInverted ? (y >= 0.0 ? CGFloat(y) : 0) : (y <= 0.0 ? CGFloat(y) : 0)
                
                // multiply the height of the rect with the phase
                if (right > 0)
                {
                    right *= phaseY
                }
                else
                {
                    left *= phaseY
                }
                
                // only for Gantt Chart in %
                var startPosition = ganttData!.startPosition as Float
                var endPosition = ganttData!.endPosition as Float
                
                var point : CGPoint = CGPoint(x: viewPortHandler.chartWidth, y: viewPortHandler.chartHeight)
                
                trans.pixelToValue(&point)
                let maxPosition = Float(point.x)
                
                startPosition = maxPosition * startPosition / 12
                endPosition = maxPosition * endPosition / 12
                
                barRect.origin.x = CGFloat(startPosition)
                barRect.size.width = CGFloat(endPosition) - CGFloat(startPosition)
                
                barRect.origin.y = top
                barRect.size.height = bottom - top
                
                trans.rectValueToPixel(&barRect)
                
                if (e === dataEntry) {
                    return barRect;
                }

                
                if (!viewPortHandler.isInBoundsLeft(barRect.origin.x + barRect.size.width))
                {
                    continue
                }
                
                if (!viewPortHandler.isInBoundsRight(barRect.origin.x))
                {
                    break
                }
                
                // if drawing the bar shadow is enabled
                if (drawBarShadowEnabled)
                {
                    barShadow.origin.x = viewPortHandler.contentLeft
                    barShadow.origin.y = barRect.origin.y
                    barShadow.size.width = viewPortHandler.contentWidth
                    barShadow.size.height = barRect.size.height
                    
//                    CGContextSetFillColorWithColor(context, dataSet.barShadowColor.CGColor)
//                    CGContextFillRect(context, barShadow)
                }
                
                // Set the color for the currently drawn value. If the index is out of bounds, reuse colors.
//                CGContextSetFillColorWithColor(context, dataSet.colorAt(j).CGColor)
//                CGContextFillRect(context, barRect)
            }
            else
            {
                let vals = values!
                var posY = 0.0
                var negY = -e.negativeSum
                var yStart = 0.0
                
                // if drawing the bar shadow is enabled
                if (drawBarShadowEnabled)
                {
                    y = e.value
                    
                    let bottom = x - barWidth + barSpaceHalf
                    let top = x + barWidth - barSpaceHalf
                    var right = isInverted ? (y <= 0.0 ? CGFloat(y) : 0) : (y >= 0.0 ? CGFloat(y) : 0)
                    var left = isInverted ? (y >= 0.0 ? CGFloat(y) : 0) : (y <= 0.0 ? CGFloat(y) : 0)
                    
                    // multiply the height of the rect with the phase
                    if (right > 0)
                    {
                        right *= phaseY
                    }
                    else
                    {
                        left *= phaseY
                    }
                    
                    barRect.origin.x = left
                    barRect.size.width = right - left
                    barRect.origin.y = top
                    barRect.size.height = bottom - top
                    
                    trans.rectValueToPixel(&barRect)
                    
                    barShadow.origin.x = viewPortHandler.contentLeft
                    barShadow.origin.y = barRect.origin.y
                    barShadow.size.width = viewPortHandler.contentWidth
                    barShadow.size.height = barRect.size.height
                    
//                    CGContextSetFillColorWithColor(context, dataSet.barShadowColor.CGColor)
//                    CGContextFillRect(context, barShadow)
                }
                
                // fill the stack
                for (var k = 0; k < vals.count; k++)
                {
                    let value = vals[k]
                    
                    if value >= 0.0
                    {
                        y = posY
                        yStart = posY + value
                        posY = yStart
                    }
                    else
                    {
                        y = negY
                        yStart = negY + abs(value)
                        negY += abs(value)
                    }
                    
                    let bottom = x - barWidth + barSpaceHalf
                    let top = x + barWidth - barSpaceHalf
                    var right: CGFloat, left: CGFloat
                    if isInverted
                    {
                        left = y >= yStart ? CGFloat(y) : CGFloat(yStart)
                        right = y <= yStart ? CGFloat(y) : CGFloat(yStart)
                    }
                    else
                    {
                        right = y >= yStart ? CGFloat(y) : CGFloat(yStart)
                        left = y <= yStart ? CGFloat(y) : CGFloat(yStart)
                    }
                    
                    // multiply the height of the rect with the phase
                    right *= phaseY
                    left *= phaseY
                    
                    barRect.origin.x = left
                    barRect.size.width = right - left
                    barRect.origin.y = top
                    barRect.size.height = bottom - top
                    
//                    print("\(barRect)" + " " + "\(e)")
//                    print("\(e)" + " <> " + "\(dataEntry)")
                    trans.rectValueToPixel(&barRect)
                    
                    if (e === dataEntry) {
                        return barRect;
                    }
                    
                    
                    if (k == 0 && !viewPortHandler.isInBoundsTop(barRect.origin.y + barRect.size.height))
                    {
                        // Skip to next bar
                        break
                    }
                    
                    // avoid drawing outofbounds values
                    if (!viewPortHandler.isInBoundsBottom(barRect.origin.y))
                    {
                        break
                    }
                    
                    // Set the color for the currently drawn value. If the index is out of bounds, reuse colors.
//                    CGContextSetFillColorWithColor(context, dataSet.colorAt(k).CGColor)
//                    CGContextFillRect(context, barRect)
                }
            }
        }
        
//        CGContextRestoreGState(context)
        
        return CGRectZero
    }
    
    internal override func drawDataSet(context context: CGContext, dataSet: BarChartDataSet, index: Int)
    {
        guard let dataProvider = dataProvider, barData = dataProvider.barData else { return }
        
        CGContextSaveGState(context)
        
        let trans = dataProvider.getTransformer(dataSet.axisDependency)
        
        let drawBarShadowEnabled: Bool = dataProvider.isDrawBarShadowEnabled
        let dataSetOffset = (barData.dataSetCount - 1)
        let groupSpace = barData.groupSpace
        let groupSpaceHalf = groupSpace / 2.0
        let barSpace = dataSet.barSpace
        let barSpaceHalf = barSpace / 2.0
        let containsStacks = dataSet.isStacked
        let isInverted = dataProvider.isInverted(dataSet.axisDependency)
        var entries = dataSet.yVals as! [BarChartDataEntry]
        let barWidth: CGFloat = 0.5
        let phaseY = _animator.phaseY
        var barRect = CGRect()
        var barShadow = CGRect()
        var y: Double
        
        // do the drawing
        for (var j = 0, count = Int(ceil(CGFloat(dataSet.entryCount) * _animator.phaseX)); j < count; j++)
        {
            let e = entries[j]
            
            let ganttData = e.data as? GanttChartData
            
            if (ganttData?.title.characters.count == 0) {
                continue
            }
            
            // calculate the x-position, depending on datasetcount
            let x = CGFloat(e.xIndex + e.xIndex * dataSetOffset) + CGFloat(index)
                + groupSpace * CGFloat(e.xIndex) + groupSpaceHalf
            let values = e.values
            
            if (!containsStacks || values == nil)
            {
                y = e.value
                
                let bottom = x - barWidth + barSpaceHalf
                let top = x + barWidth - barSpaceHalf
                var right = isInverted ? (y <= 0.0 ? CGFloat(y) : 0) : (y >= 0.0 ? CGFloat(y) : 0)
                var left = isInverted ? (y >= 0.0 ? CGFloat(y) : 0) : (y <= 0.0 ? CGFloat(y) : 0)
                
                // multiply the height of the rect with the phase
                if (right > 0)
                {
                    right *= phaseY
                }
                else
                {
                    left *= phaseY
                }
                
                // only for Gantt Chart in %
                var startPosition = ganttData!.startPosition as Float
                var endPosition = ganttData!.endPosition as Float
                
                var point : CGPoint = CGPoint(x: viewPortHandler.chartWidth, y: viewPortHandler.chartHeight)
                
                trans.pixelToValue(&point)
                let maxPosition = Float(point.x)
                
                startPosition = (maxPosition * startPosition / 12) - 1.1
                endPosition = maxPosition * endPosition / 12 - 1
                
                barRect.origin.x = CGFloat(startPosition)
                barRect.size.width = CGFloat(endPosition) - CGFloat(startPosition)

                barRect.origin.y = top
                barRect.size.height = bottom - top
                
                trans.rectValueToPixel(&barRect)
                
                if (!viewPortHandler.isInBoundsLeft(barRect.origin.x + barRect.size.width))
                {
                    continue
                }
                
                if (!viewPortHandler.isInBoundsRight(barRect.origin.x))
                {
                    break
                }
                
                // if drawing the bar shadow is enabled
                if (drawBarShadowEnabled)
                {
                    barShadow.origin.x = viewPortHandler.contentLeft
                    barShadow.origin.y = barRect.origin.y
                    barShadow.size.width = viewPortHandler.contentWidth
                    barShadow.size.height = barRect.size.height
                    
                    CGContextSetFillColorWithColor(context, dataSet.barShadowColor.CGColor)
                    CGContextFillRect(context, barShadow)
                }
                
                // Set the color for the currently drawn value. If the index is out of bounds, reuse colors.
                CGContextSetFillColorWithColor(context, dataSet.colorAt(j).CGColor)
                CGContextFillRect(context, barRect)
            }
            else
            {
                let vals = values!
                var posY = 0.0
                var negY = -e.negativeSum
                var yStart = 0.0
                
                // if drawing the bar shadow is enabled
                if (drawBarShadowEnabled)
                {
                    y = e.value
                    
                    let bottom = x - barWidth + barSpaceHalf
                    let top = x + barWidth - barSpaceHalf
                    var right = isInverted ? (y <= 0.0 ? CGFloat(y) : 0) : (y >= 0.0 ? CGFloat(y) : 0)
                    var left = isInverted ? (y >= 0.0 ? CGFloat(y) : 0) : (y <= 0.0 ? CGFloat(y) : 0)
                    
                    // multiply the height of the rect with the phase
                    if (right > 0)
                    {
                        right *= phaseY
                    }
                    else
                    {
                        left *= phaseY
                    }
                    
                    barRect.origin.x = left
                    barRect.size.width = right - left
                    barRect.origin.y = top
                    barRect.size.height = bottom - top
                    
                    trans.rectValueToPixel(&barRect)
                    
                    barShadow.origin.x = viewPortHandler.contentLeft
                    barShadow.origin.y = barRect.origin.y
                    barShadow.size.width = viewPortHandler.contentWidth
                    barShadow.size.height = barRect.size.height
                    
                    CGContextSetFillColorWithColor(context, dataSet.barShadowColor.CGColor)
                    CGContextFillRect(context, barShadow)
                }
                
                // fill the stack
                for (var k = 0; k < vals.count; k++)
                {
                    let value = vals[k]
                    
                    if value >= 0.0
                    {
                        y = posY
                        yStart = posY + value
                        posY = yStart
                    }
                    else
                    {
                        y = negY
                        yStart = negY + abs(value)
                        negY += abs(value)
                    }
                    
                    let bottom = x - barWidth + barSpaceHalf
                    let top = x + barWidth - barSpaceHalf
                    var right: CGFloat, left: CGFloat
                    if isInverted
                    {
                        left = y >= yStart ? CGFloat(y) : CGFloat(yStart)
                        right = y <= yStart ? CGFloat(y) : CGFloat(yStart)
                    }
                    else
                    {
                        right = y >= yStart ? CGFloat(y) : CGFloat(yStart)
                        left = y <= yStart ? CGFloat(y) : CGFloat(yStart)
                    }
                    
                    // multiply the height of the rect with the phase
                    right *= phaseY
                    left *= phaseY
                    
                    barRect.origin.x = left
                    barRect.size.width = right - left
                    barRect.origin.y = top
                    barRect.size.height = bottom - top
                    
                    trans.rectValueToPixel(&barRect)
                    
                    if (k == 0 && !viewPortHandler.isInBoundsTop(barRect.origin.y + barRect.size.height))
                    {
                        // Skip to next bar
                        break
                    }
                    
                    // avoid drawing outofbounds values
                    if (!viewPortHandler.isInBoundsBottom(barRect.origin.y))
                    {
                        break
                    }
                    
                    // Set the color for the currently drawn value. If the index is out of bounds, reuse colors.
                    CGContextSetFillColorWithColor(context, dataSet.colorAt(k).CGColor)
                    CGContextFillRect(context, barRect)
                }
            }
        }
        
        CGContextRestoreGState(context)
    }
    
    internal override func prepareBarHighlight(x x: CGFloat, y1: Double, y2: Double, barspacehalf: CGFloat, trans: ChartTransformer, inout rect: CGRect)
    {
        let barWidth: CGFloat = 0.5
        
        let top = x - barWidth + barspacehalf
        let bottom = x + barWidth - barspacehalf
        let left = CGFloat(y1)
        let right = CGFloat(y2)
        
        rect.origin.x = left
        rect.origin.y = top
        rect.size.width = right - left
        rect.size.height = bottom - top
        
        trans.rectValueToPixelHorizontal(&rect, phaseY: _animator.phaseY)
    }
    
    public override func getTransformedValues(trans trans: ChartTransformer, entries: [BarChartDataEntry], dataSetIndex: Int) -> [CGPoint]
    {
        return trans.generateTransformedValuesHorizontalBarChart(entries, dataSet: dataSetIndex, barData: dataProvider!.barData!, phaseY: _animator.phaseY)
    }
    
    public override func drawValues(context context: CGContext)
    {
        // if values are drawn
        if (passesCheck())
        {
            guard let dataProvider = dataProvider, barData = dataProvider.barData else { return }
            
            var dataSets = barData.dataSets
            
            let drawValueAboveBar = dataProvider.isDrawValueAboveBarEnabled
            
            let textAlign = drawValueAboveBar ? NSTextAlignment.Left : NSTextAlignment.Right
            
            let valueOffsetPlus: CGFloat = 5.0
            var posOffset: CGFloat
            var negOffset: CGFloat
            
            for (var i = 0, count = barData.dataSetCount; i < count; i++)
            {
                let dataSet = dataSets[i] as! BarChartDataSet
                
                if !dataSet.isDrawValuesEnabled || dataSet.entryCount == 0
                {
                    continue
                }
                
                let isInverted = dataProvider.isInverted(dataSet.axisDependency)
                
                let valueFont = dataSet.valueFont
                let valueTextColor = dataSet.valueTextColor
                let yOffset = -valueFont.lineHeight / 2.0
                
                let formatter = dataSet.valueFormatter
                
                let trans = dataProvider.getTransformer(dataSet.axisDependency)
                
                var entries = dataSet.yVals as! [BarChartDataEntry]
                
                var valuePoints = getTransformedValues(trans: trans, entries: entries, dataSetIndex: i)
                
                // if only single values are drawn (sum)
                if (!dataSet.isStacked)
                {
                    for (var j = 0, count = Int(ceil(CGFloat(valuePoints.count) * _animator.phaseX)); j < count; j++)
                    {
                        
                        let ganttData = entries[j].data as? GanttChartData
                        
                        if (ganttData?.title.characters.count == 0) {
                            continue
                        }
                        
                        
                        if (!viewPortHandler.isInBoundsTop(valuePoints[j].y))
                        {
                            break
                        }
                        
                        if (!viewPortHandler.isInBoundsX(valuePoints[j].x))
                        {
                            continue
                        }
                        
                        if (!viewPortHandler.isInBoundsBottom(valuePoints[j].y))
                        {
                            continue
                        }
                        
                        let val = entries[j].value
                        
                        
                        
                        // only for Gantt Chart
                        let startPosition = ganttData!.startPosition as Float
                        let endPosition = ganttData!.endPosition as Float
                        
                        let months = endPosition - startPosition
                        
                        var valueText = formatter!.stringFromNumber(val)!
                        if (months > 1) {
                            valueText = String(format: "%@ Months", NSNumber(float: months))
                        } else {
                            valueText = String(format: "1 Month")
                        }
                        
                        // calculate the correct offset depending on the draw position of the value
                        let valueTextWidth = valueText.sizeWithAttributes([NSFontAttributeName: valueFont]).width
                        posOffset = (drawValueAboveBar ? valueOffsetPlus : -(valueTextWidth + valueOffsetPlus))
                        negOffset = (drawValueAboveBar ? -(valueTextWidth + valueOffsetPlus) : valueOffsetPlus)
                        
                        if (isInverted)
                        {
                            posOffset = -posOffset - valueTextWidth
                            negOffset = -negOffset - valueTextWidth
                        }
                        
                        if (valueLabelAnchorCenter == true) {
                            
//                            J: 0: 144.913/232.789
//                            EntryRect: (35.0, 226.299, 109.913, 12.98)
//                            X: 149.913) Y: 226.889
//                            
//                            J: 1: 177.479/218.367
//                            EntryRect: (35.0, 211.877, 142.479, 12.98)
//                            X: 182.479) Y: 212.467
//                            
//                            J: 2: 222.258/203.944
//                            EntryRect: (35.0, 197.454, 187.258, 12.98)
//                            X: 227.258) Y: 198.044
                            
                            let x = valuePoints[j].x
                            let y = valuePoints[j].y
                            
//                            print("J: \(j): \(x)" + "/" + "\(y)")
                            
                            let entryRect = rectForEntry(context: context, dataSet: dataSet, dataEntry: entries[j], valueIndex: j)
                            
//                            print("EntryRect: \(entryRect)")
                            
                            let xPos: CGFloat = (val >= 0.0 ? posOffset : negOffset) + entryRect.origin.x + (entryRect.size.width - valueTextWidth) / 2
//                            let xPos: CGFloat = valuePoints[j].x
                            let yPos: CGFloat = valuePoints[j].y + yOffset
                            
                            drawValue(
                                context: context,
                                value: valueText,
                                xPos:  xPos,
                                yPos: yPos,
                                font: valueFont,
                                align: .Center,
                                color: valueTextColor)
                            
//                            print("X: \(xPos)) Y: \(yPos)")
//                            print("")
                        } else {
                            
                            let x = valuePoints[j].x
                            let y = valuePoints[j].y
                            
//                            print("J: \(j): \(x)" + "/" + "\(y)")
                            
                            let entryRect = rectForEntry(context: context, dataSet: dataSet, dataEntry: entries[j], valueIndex: j)
                            
//                            print("EntryRect: \(entryRect)")
                            
                            let xPos: CGFloat = valuePoints[j].x + (val >= 0.0 ? posOffset : negOffset)
                            let yPos: CGFloat = valuePoints[j].y + yOffset
                            
                            drawValue(
                                context: context,
                                value: valueText,
                                xPos:  xPos,
                                yPos: yPos,
                                font: valueFont,
                                align: .Center,
                                color: valueTextColor)
                            
//                            print("X: \(xPos)) Y: \(yPos)")
//                            print("")
                        }
                        
                    }
                }
                else
                {
                    // if each value of a potential stack should be drawn
                    
                    for (var j = 0, count = Int(ceil(CGFloat(valuePoints.count) * _animator.phaseX)); j < count; j++)
                    {
                        let e = entries[j]
                        
                        let values = e.values
                        
                        // we still draw stacked bars, but there is one non-stacked in between
                        if (values == nil)
                        {
                            if (!viewPortHandler.isInBoundsTop(valuePoints[j].y))
                            {
                                break
                            }
                            
                            if (!viewPortHandler.isInBoundsX(valuePoints[j].x))
                            {
                                continue
                            }
                            
                            if (!viewPortHandler.isInBoundsBottom(valuePoints[j].y))
                            {
                                continue
                            }
                            
                            let val = e.value
                            let valueText = formatter!.stringFromNumber(val)!
                            
                            // calculate the correct offset depending on the draw position of the value
                            let valueTextWidth = valueText.sizeWithAttributes([NSFontAttributeName: valueFont]).width
                            posOffset = (drawValueAboveBar ? valueOffsetPlus : -(valueTextWidth + valueOffsetPlus))
                            negOffset = (drawValueAboveBar ? -(valueTextWidth + valueOffsetPlus) : valueOffsetPlus)
                            
                            if (isInverted)
                            {
                                posOffset = -posOffset - valueTextWidth
                                negOffset = -negOffset - valueTextWidth
                            }
                            
                            drawValue(
                                context: context,
                                value: valueText,
                                xPos: valuePoints[j].x + (val >= 0.0 ? posOffset : negOffset),
                                yPos: valuePoints[j].y + yOffset,
                                font: valueFont,
                                align: textAlign,
                                color: valueTextColor)
                        }
                        else
                        {
                            let vals = values!
                            var transformed = [CGPoint]()
                            
                            var posY = 0.0
                            var negY = -e.negativeSum
                            
                            for (var k = 0; k < vals.count; k++)
                            {
                                let value = vals[k]
                                var y: Double
                                
                                if value >= 0.0
                                {
                                    posY += value
                                    y = posY
                                }
                                else
                                {
                                    y = negY
                                    negY -= value
                                }
                                
                                transformed.append(CGPoint(x: CGFloat(y) * _animator.phaseY, y: 0.0))
                            }
                            
                            trans.pointValuesToPixel(&transformed)
                            
                            for (var k = 0; k < transformed.count; k++)
                            {
                                let val = vals[k]
                                let valueText = formatter!.stringFromNumber(val)!
                                
                                // calculate the correct offset depending on the draw position of the value
                                let valueTextWidth = valueText.sizeWithAttributes([NSFontAttributeName: valueFont]).width
                                posOffset = (drawValueAboveBar ? valueOffsetPlus : -(valueTextWidth + valueOffsetPlus))
                                negOffset = (drawValueAboveBar ? -(valueTextWidth + valueOffsetPlus) : valueOffsetPlus)
                                
                                if (isInverted)
                                {
                                    posOffset = -posOffset - valueTextWidth
                                    negOffset = -negOffset - valueTextWidth
                                }
                                
                                let x = transformed[k].x + (val >= 0 ? posOffset : negOffset)
                                let y = valuePoints[j].y
                                
                                if (!viewPortHandler.isInBoundsTop(y))
                                {
                                    break
                                }
                                
                                if (!viewPortHandler.isInBoundsX(x))
                                {
                                    continue
                                }
                                
                                if (!viewPortHandler.isInBoundsBottom(y))
                                {
                                    continue
                                }
                                
                                drawValue(context: context,
                                    value: valueText,
                                    xPos: x,
                                    yPos: y + yOffset,
                                    font: valueFont,
                                    align: textAlign,
                                    color: valueTextColor)
                            }
                        }
                    }
                }
            }
        }
    }
    
    internal override func passesCheck() -> Bool
    {
        guard let dataProvider = dataProvider, barData = dataProvider.barData else { return false }
        
        return CGFloat(barData.yValCount) < CGFloat(dataProvider.maxVisibleValueCount) * viewPortHandler.scaleY
    }
}