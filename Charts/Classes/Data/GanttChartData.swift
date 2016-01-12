//
//  GanttChartData.swift
//  Charts
//
//  Created by Vadim Osovets on 1/12/16.
//  Copyright © 2016 dcg. All rights reserved.
//

import Foundation

import Foundation

public class GanttChartData: NSObject
{
    /// the actual value (y axis)
    public var title = ""
    
    /// the actual value (y axis)
    public var startPosition = Float(0)
    
    public var endPosition = Float(10)
    
    public override required init()
    {
        super.init()
    }
    
//    public init(value: Double, xIndex: Int)
//    {
//        super.init()
//        
//        self.value = value
//        self.xIndex = xIndex
//    }
//    
//    public init(value: Double, xIndex: Int, data: AnyObject?)
//    {
//        super.init()
//        
//        self.value = value
//        self.xIndex = xIndex
//        self.data = data
//    }
//    
//    // MARK: NSObject
//    
//    public override func isEqual(object: AnyObject?) -> Bool
//    {
//        if (object === nil)
//        {
//            return false
//        }
//        
//        if (!object!.isKindOfClass(self.dynamicType))
//        {
//            return false
//        }
//        
//        if (object!.data !== data && !object!.data.isEqual(self.data))
//        {
//            return false
//        }
//        
//        if (object!.xIndex != xIndex)
//        {
//            return false
//        }
//        
//        if (fabs(object!.value - value) > 0.00001)
//        {
//            return false
//        }
//        
//        return true
//    }
//    
//    // MARK: NSObject
//    
//    public override var description: String
//        {
//            return "ChartDataEntry, xIndex: \(xIndex), value \(value)"
//    }
//    
//    // MARK: NSCopying
//    
//    public func copyWithZone(zone: NSZone) -> AnyObject
//    {
//        let copy = self.dynamicType.init()
//        
//        copy.value = value
//        copy.xIndex = xIndex
//        copy.data = data
//        
//        return copy
//    }
//}
//
//public func ==(lhs: ChartDataEntry, rhs: ChartDataEntry) -> Bool
//{
//    if (lhs === rhs)
//    {
//        return true
//    }
//    
//    if (!lhs.isKindOfClass(rhs.dynamicType))
//    {
//        return false
//    }
//    
//    if (lhs.data !== rhs.data && !lhs.data!.isEqual(rhs.data))
//    {
//        return false
//    }
//    
//    if (lhs.xIndex != rhs.xIndex)
//    {
//        return false
//    }
//    
//    if (fabs(lhs.value - rhs.value) > 0.00001)
//    {
//        return false
//    }
//    
//    return true
}
