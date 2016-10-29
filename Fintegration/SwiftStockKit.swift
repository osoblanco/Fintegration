
// The MIT License (MIT)
//
// Copyright (c) 2016 Michael Ackley (ackleymi@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


import UIKit
import Alamofire

struct StockSearchResult {
    var symbol: String?
    var name: String?
    var exchange: String?
    var assetType: String?
    
    
}

struct Stock {
    
    var ask: String?
    var averageDailyVolume: String?
    var bid: String?
    var bookValue: String?
    var changeNumeric: String?
    var changePercent: String?
    var dayHigh: String?
    var dayLow: String?
    var dividendShare: String?
    var dividendYield: String?
    var ebitda: String?
    var epsEstimateCurrentYear: String?
    var epsEstimateNextQtr: String?
    var epsEstimateNextYr: String?
    var eps: String?
    var fiftydayMovingAverage: String?
    var lastTradeDate: String?
    var last: String?
    var lastTradeTime: String?
    var marketCap: String?
    var companyName: String?
    var oneYearTarget: String?
    var open: String?
    var pegRatio: String?
    var peRatio: String?
    var previousClose: String?
    var priceBook: String?
    var priceSales: String?
    var shortRatio: String?
    var stockExchange: String?
    var symbol: String?
    var twoHundreddayMovingAverage: String?
    var volume: String?
    var yearHigh: String?
    var yearLow: String?
    
    var dataFields: [[String : String]]
    
}

struct ChartPoint {
    var date: Date?
    var volume: Int?
    var open: CGFloat?
    var close: CGFloat?
    var low: CGFloat?
    var high: CGFloat?

}

enum ChartTimeRange {
    case oneDay, fiveDays, tenDays, oneMonth, threeMonths, oneYear, fiveYears
}



class SwiftStockKit {
    
    class func fetchStocksFromSearchTerm(term: String, completion:@escaping (_ stockInfoArray: [StockSearchResult]) -> ()) {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            
            let searchURL = "http://autoc.finance.yahoo.com/autoc"
            Alamofire.request(searchURL, method: .get, parameters: ["query": term, "region": 2, "lang": "en"])
                .responseJSON{ response in
                if let resultJSON = response.result.value as? [String : AnyObject]  {

                    if let jsonArray = (resultJSON["ResultSet"] as! [String : AnyObject])["Result"] as? [[String : String]] {

                        var stockInfoArray = [StockSearchResult]()
                        for dictionary in jsonArray {
                            stockInfoArray.append(StockSearchResult(symbol: dictionary["symbol"], name: dictionary["name"], exchange: dictionary["exchDisp"], assetType: dictionary["typeDisp"]))
                        }
                        
                        DispatchQueue.main.async {
                            completion(stockInfoArray)

                        }
                    }
                }
            }
        }
    }
    
    class func fetchStockForSymbol(symbol: String, completion:@escaping (_ stock: Stock?) -> ()) {
        
            let stockURL = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22\(symbol)%22)&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&format=json"
                    
            Alamofire.request(stockURL, method: .get).responseJSON { response in
               
                if let resultJSON = response.result.value as? [String : AnyObject]  {
                    
                    if let _  = resultJSON["error"] {
                        completion(nil)
                        return
                    }
                    
                    if let stockData = ((resultJSON["query"] as! [String : AnyObject])["results"] as! [String : AnyObject])["quote"] as? [String : AnyObject] {
                        
                    
                        // lengthy creation, yeah
                        var dataFields = [[String : String]]()
                        
                        dataFields.append(["Ask" : stockData["Ask"] as? String ?? "N/A"])
                        dataFields.append(["Average Daily Volume" : stockData["AverageDailyVolume"] as? String ?? "N/A"])
                        dataFields.append(["Bid" : stockData["Bid"] as? String ?? "N/A"])
                        dataFields.append(["Book Value" : stockData["BookValue"] as? String ?? "N/A"])
                        dataFields.append(["Change" : stockData["Change"] as? String ?? "N/A"])
                        dataFields.append(["Percent Change" : stockData["ChangeinPercent"] as? String ?? "N/A"])
                        dataFields.append(["Day High" : stockData["DaysHigh"] as? String ?? "N/A"])
                        dataFields.append(["Day Low" : stockData["DaysLow"] as? String ?? "N/A"])
                        dataFields.append(["Div/Share" : stockData["DividendShare"] as? String ?? "N/A"])
                        dataFields.append(["Div Yield" : stockData["DividendYield"] as? String ?? "N/A"])
                        dataFields.append(["EBITDA" : stockData["EBITDA"] as? String ?? "N/A"])
                        dataFields.append(["Current Yr EPS Estimate" : stockData["EPSEstimateCurrentYear"] as? String ?? "N/A"])
                        dataFields.append(["Next Qtr EPS Estimate" : stockData["EPSEstimateNextQuarter"] as? String ?? "N/A"])
                        dataFields.append(["Next Yr EPS Estimate" : stockData["EPSEstimateNextYear"] as? String ?? "N/A"])
                        dataFields.append(["Earnings/Share" : stockData["EarningsShare"] as? String ?? "N/A"])
                        dataFields.append(["50D MA" : stockData["FiftydayMovingAverage"] as? String ?? "N/A"])
                        dataFields.append(["Last Trade Date" : stockData["LastTradeDate"] as? String ?? "N/A"])
                        dataFields.append(["Last" : stockData["LastTradePriceOnly"] as? String ?? "N/A"])
                        dataFields.append(["Last Trade Time" : stockData["LastTradeTime"] as? String ?? "N/A"])
                        dataFields.append(["Market Cap" : stockData["MarketCapitalization"] as? String ?? "N/A"])
                        dataFields.append(["Company" : stockData["Name"] as? String ?? "N/A"])
                        dataFields.append(["One Yr Target" : stockData["OneyrTargetPrice"] as? String ?? "N/A"])
                        dataFields.append(["Open" : stockData["Open"] as? String ?? "N/A"])
                        dataFields.append(["PEG Ratio" : stockData["PEGRatio"] as? String ?? "N/A"])
                        dataFields.append(["PE Ratio" : stockData["PERatio"] as? String ?? "N/A"])
                        dataFields.append(["Previous Close" : stockData["PreviousClose"] as? String ?? "N/A"])
                        dataFields.append(["Price-Book" : stockData["PriceBook"] as? String ?? "N/A"])
                        dataFields.append(["Price-Sales" : stockData["PriceSales"] as? String ?? "N/A"])
                        dataFields.append(["Short Ratio" : stockData["ShortRatio"] as? String ?? "N/A"])
                        dataFields.append(["Stock Exchange" : stockData["StockExchange"] as? String ?? "N/A"])
                        dataFields.append(["Symbol" : stockData["Symbol"] as? String ?? "N/A"])
                        dataFields.append(["200D MA" : stockData["TwoHundreddayMovingAverage"] as? String ?? "N/A"])
                        dataFields.append(["Volume" : stockData["Volume"] as? String ?? "N/A"])
                        dataFields.append(["52w High" : stockData["YearHigh"] as? String ?? "N/A"])
                        dataFields.append(["52w Low" : stockData["YearLow"] as? String ?? "N/A"])

                        let stock = Stock(
                            ask: dataFields[0].values.first,
                            averageDailyVolume: dataFields[1].values.first,
                            bid: dataFields[2].values.first,
                            bookValue: dataFields[3].values.first,
                            changeNumeric: dataFields[4].values.first,
                            changePercent: dataFields[5].values.first,
                            dayHigh: dataFields[6].values.first,
                            dayLow: dataFields[7].values.first,
                            dividendShare: dataFields[8].values.first,
                            dividendYield: dataFields[9].values.first,
                            ebitda: dataFields[10].values.first,
                            epsEstimateCurrentYear: dataFields[11].values.first,
                            epsEstimateNextQtr: dataFields[12].values.first,
                            epsEstimateNextYr: dataFields[13].values.first,
                            eps: dataFields[14].values.first,
                            fiftydayMovingAverage: dataFields[15].values.first,
                            lastTradeDate: dataFields[16].values.first,
                            last: dataFields[17].values.first,
                            lastTradeTime: dataFields[18].values.first,
                            marketCap: dataFields[19].values.first,
                            companyName: dataFields[20].values.first,
                            oneYearTarget: dataFields[21].values.first,
                            open: dataFields[22].values.first,
                            pegRatio: dataFields[23].values.first,
                            peRatio: dataFields[24].values.first,
                            previousClose: dataFields[25].values.first,
                            priceBook: dataFields[26].values.first,
                            priceSales: dataFields[27].values.first,
                            shortRatio: dataFields[28].values.first,
                            stockExchange: dataFields[29].values.first,
                            symbol: dataFields[30].values.first,
                            twoHundreddayMovingAverage: dataFields[31].values.first,
                            volume: dataFields[32].values.first,
                            yearHigh: dataFields[33].values.first,
                            yearLow: dataFields[34].values.first,
                            dataFields: dataFields
                        )
                        DispatchQueue.main.async {
                            completion(stock)
                        }
                    }
                }
            }
    }
   
    class func fetchChartPoints(symbol: String, range: ChartTimeRange, completion:@escaping (_ chartPoints: [ChartPoint]) -> ()) {
    
            //An Alamofire regular responseJSON wont parse the JSONP with a callback wrapper correctly, so lets work around that.
            let chartURL = SwiftStockKit.chartUrlForRange(symbol, range: range)
            
            Alamofire.request(chartURL, method: .get).responseData { response in
  
                if let data = response.result.value {

                    var jsonString =  NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                    
                    jsonString = jsonString.substring(from: 30) as NSString
                    jsonString = jsonString.substring(to: jsonString.length-1) as NSString
                    
                    if let data = jsonString.data(using: String.Encoding.utf8.rawValue) {
                        if let resultJSON = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)))  as? [String : AnyObject] {
                            
                            guard let series = resultJSON["series"] as? [[String : AnyObject]] else {
                                completion([])
                                return
                            }
                            var chartPoints = [ChartPoint]()
                            for dataPoint in series {
                                //GMT off by 5 hrs
                                 let date = NSDate(timeIntervalSince1970: (dataPoint["Timestamp"] as? Double ?? dataPoint["Date"] as! Double) - 18000.0)
                                
                                chartPoints.append(
                                    ChartPoint(
                                    date:  date as Date,
                                    volume: dataPoint["volume"] as? Int,
                                    open: dataPoint["open"] as? CGFloat,
                                    close: dataPoint["close"] as? CGFloat,
                                    low: dataPoint["low"] as? CGFloat,
                                    high: dataPoint["high"] as? CGFloat
                                    )
                                )
                            }
                            
                            DispatchQueue.main.async {
                                completion(chartPoints)
                            }
                        }
                    }
                }
            }
    }
    
    class func chartUrlForRange(_ symbol: String, range: ChartTimeRange) -> String {
    
        var timeString = String()
        
        switch (range) {
        case .oneDay:
            timeString = "1d"
        case .fiveDays:
            timeString = "5d"
        case .tenDays:
            timeString = "10d"
        case .oneMonth:
            timeString = "1m"
        case .threeMonths:
            timeString = "3m"
        case .oneYear:
            timeString = "1y"
        case .fiveYears:
            timeString = "5y"
        }
        
        return "http://chartapi.finance.yahoo.com/instrument/1.0/\(symbol)/chartdata;type=quote;range=\(timeString)/json"
    }

}


class SwiftStockChart: UIView {
    
    enum ValueLabelPositionType {
        case left, right, mirrored
    }
    
    typealias LabelForIndexGetter = ((_ index: NSInteger) -> String)!
    typealias LabelForValueGetter = ((_ value: CGFloat) -> String)!

    //Index Label Properties
    var labelForIndex: ((_ index: NSInteger) -> String)!
    var indexLabelFont: UIFont?
    var indexLabelTextColor: UIColor?
    var indexLabelBackgroundColor: UIColor?
    
    // Value label properties
    var labelForValue: ((_ value: CGFloat) -> String)!
    var valueLabelFont: UIFont?
    var valueLabelTextColor: UIColor?
    var valueLabelBackgroundColor: UIColor?
    var valueLabelPosition: ValueLabelPositionType?
    
    // Number of visible step in the chart
    var gridStep: Int?
    var verticalGridStep: Int?
    var horizontalGridStep: Int?

    // Margin of the chart
    var margin: CGFloat?
    
    var axisWidth: CGFloat?
    var axisHeight: CGFloat?

    // Decoration parameters, let you pick the color of the line as well as the color of the axis
    var axisColor: UIColor?
    var axisLineWidth: CGFloat?
    
    // Chart parameters
    var color: UIColor?
    var fillColor: UIColor?
    var lineWidth: CGFloat?
    
    // Data points
    var displayDataPoint: Bool?
    var dataPointColor: UIColor?
    var dataPointBackgroundColor: UIColor?
    var dataPointRadius: CGFloat?
    
    // Grid parameters
    var drawInnerGrid: Bool?
    var innerGridColor: UIColor?
    var innerGridLineWidth: CGFloat?
    // Smoothing
    var bezierSmoothing: Bool?
    var bezierSmoothingTension: CGFloat?
    
    // Animations
    var animationDuration: CGFloat?

    var timeRange: ChartTimeRange!
    var dataPoints = [ChartPoint]()
    var layers = [CAShapeLayer]()
    var axisLabels = [UILabel]()
    var minValue: CGFloat?
    var maxValue: CGFloat?
    var initialPath: CGMutablePath?
    var newPath: CGMutablePath?

    
    //Implementation
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        color = UIColor.green
        fillColor = color?.withAlphaComponent(0.25)
        verticalGridStep = 3
        horizontalGridStep = 3
        margin = 5.0
        axisWidth = self.frame.size.width - 2 * margin!
        axisHeight = self.frame.size.height - 2 * margin!
        axisColor = UIColor(white: 0.5, alpha: 1.0)
        innerGridColor = UIColor(white: 0.9, alpha: 1.0)
        drawInnerGrid = false
        bezierSmoothing = false
        bezierSmoothingTension = 0.2
        lineWidth = 1
        innerGridLineWidth = 0.5
        axisLineWidth = 1
        animationDuration = 0.0
        displayDataPoint = false
        dataPointRadius = 1.0
        dataPointColor = color
        dataPointBackgroundColor = color
        
        indexLabelBackgroundColor = UIColor.clear
        indexLabelTextColor = UIColor(white: 1, alpha: 0.6)
        indexLabelFont = UIFont(name: "HelveticaNeue-Light", size: 10)
        
        valueLabelBackgroundColor = UIColor.clear
        valueLabelTextColor = UIColor(white: 1, alpha: 0.6)
        valueLabelFont = UIFont(name: "HelveticaNeue-Light", size: 11)
        valueLabelPosition = .right
        

    }
    
    func setChartPoints(points: [ChartPoint]) {
    
        if points.isEmpty { return }
        
        dataPoints = points
    
        computeBounds()
        
        
        if maxValue!.isNaN { maxValue = 1.0 }
        
        for i in 0 ..< verticalGridStep! {
            
            let yVal = axisHeight! + margin! - CGFloat((i + 1)) * axisHeight! / CGFloat(verticalGridStep!)
            let p = CGPoint(x: (valueLabelPosition! == .right ? axisWidth! : 0), y: yVal)

            let text = labelForValue(minValue! + (maxValue! - minValue!) / CGFloat(verticalGridStep!) * CGFloat((i + 1)))
            
            let rect = CGRect(x: margin!,  y: p.y + 2, width: self.frame.size.width - margin! * 2 - 4.0, height: 14.0)
            let width = text.boundingRect(with: rect.size,
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes:[NSFontAttributeName : valueLabelFont!],
                context: nil).size.width
            
            let xPadding = 6
            let xOffset = width + CGFloat(xPadding)
            
            let label = UILabel(frame: CGRect(x: p.x - xOffset + 5.0, y: p.y, width: width + 2, height: 14))
            label.text = text
            label.font = valueLabelFont
            label.textColor = valueLabelTextColor
            label.textAlignment = .center
            label.backgroundColor = valueLabelBackgroundColor!
            
            self.addSubview(label)
            axisLabels.append(label)
        
        }
        
        for i in 0 ..< horizontalGridStep! + 1 {
            
            let text = labelForIndex(i)
            
            let p = CGPoint(x: margin! + CGFloat(i) * (axisWidth! / CGFloat(horizontalGridStep!)) * 1.0, y: axisHeight! + margin!)
            
        
            let rect = CGRect(x: margin!, y: p.y + 2, width: self.frame.size.width - margin! * 2 - 4.0, height: 14)
            let width = text.boundingRect(with: rect.size,
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes:[NSFontAttributeName : indexLabelFont!],
                context: nil).size.width
            
            let label = UILabel(frame: CGRect(x: p.x - 5.0, y: p.y + 5.0, width: width + 2, height: 14))
            label.text = text
            label.font = indexLabelFont!
            label.textAlignment = .left
            label.textColor = indexLabelTextColor!
            label.backgroundColor = indexLabelBackgroundColor!
            
            self.addSubview(label)
            axisLabels.append(label)
        
        }
        
        self.color = UIColor.white
            //UIColor(red: (127/255), green: (50/255), blue: (198/255), alpha: 1)
        strokeChart()
        self.setNeedsDisplay()
    
    }
    
    override func draw(_ rect: CGRect) {
        if !dataPoints.isEmpty {
            drawGrid()
        }
    }
    
    func drawGrid() {
        
        if drawInnerGrid! {
            
            let ctx = UIGraphicsGetCurrentContext()
            UIGraphicsPushContext(ctx!)
            ctx?.setLineWidth(axisLineWidth!)
            ctx?.setStrokeColor(axisColor!.cgColor)
            
            ctx?.move(to: CGPoint(x: margin!, y: margin!))
            ctx?.addLine(to: CGPoint(x: margin!, y: axisHeight! + margin! + 3))
            ctx?.strokePath()
            
            for i in 0 ..< horizontalGridStep! {
                
                ctx?.setStrokeColor(innerGridColor!.cgColor)
                ctx?.setLineWidth(innerGridLineWidth!)
                
                let point = CGPoint(x: CGFloat((1 + i)) * axisWidth! / CGFloat(horizontalGridStep!) * 1.0 + margin!, y: margin!)
                
                ctx?.move(to: CGPoint(x: point.x, y: point.y))
                ctx?.addLine(to: CGPoint(x: point.x, y: axisHeight! + margin!))
                ctx?.strokePath()
                
                ctx?.setStrokeColor(axisColor!.cgColor)
                ctx?.setLineWidth(axisLineWidth!)
                ctx?.move(to: CGPoint(x: point.x - 0.5, y: axisHeight! + margin!))
                ctx?.addLine(to: CGPoint(x: point.x - 0.5, y: axisHeight! + margin! + 3))
                ctx?.strokePath()
            
            }
        
            for i in 0 ..< verticalGridStep! + 1 {
                
                let v = maxValue! - (maxValue! - minValue!) / CGFloat(verticalGridStep! * i)
                
                if(v == minValue!) {
                    ctx?.setLineWidth(axisLineWidth!)
                    ctx?.setStrokeColor(axisColor!.cgColor)
                } else {
                    ctx?.setStrokeColor(innerGridColor!.cgColor)
                    ctx?.setLineWidth(innerGridLineWidth!)
                }
                
                let point = CGPoint(x: margin!, y: CGFloat(i) * axisHeight! / CGFloat(verticalGridStep!) + margin!)
                
                ctx?.move(to: CGPoint(x: point.x, y: point.y))
                ctx?.addLine(to: CGPoint(x: axisWidth! + margin!, y: point.y))
                ctx?.strokePath()
                
            }
        }
    
    }
    
    func clearChartData(){
        for layer in layers {
            layer.removeFromSuperlayer()
        }
        layers.removeAll()
        
        for lbl in axisLabels {
            lbl.removeFromSuperview()
        }
        axisLabels.removeAll()
    }
    
    func strokeChart(){
        
        let scale = axisHeight! / (maxValue! - minValue!)
        
        let path = getLinePath(scale: scale, smoothing: bezierSmoothing!, close: false)
        
        let pathLayer = CAShapeLayer()
        pathLayer.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y + (margin! * 1.2), width: self.bounds.size.width, height: self.bounds.size.height)
        pathLayer.bounds = self.bounds
        pathLayer.path = path.cgPath
        pathLayer.fillColor = nil
        pathLayer.strokeColor = color!.cgColor
        pathLayer.lineWidth = lineWidth!
        pathLayer.lineJoin = kCALineJoinRound
        
        self.layer.addSublayer(pathLayer)
        layers.append(pathLayer)
    
    }
    
    func computeBounds(){
        minValue = CGFloat(MAXFLOAT)
        maxValue = CGFloat(-MAXFLOAT)
        
        for i in 0 ..< dataPoints.count {
            let value = dataPoints[i].close!
         
            if value < minValue! {
                minValue = value
            }
            
            if value > maxValue! {
                maxValue = value
            }

          //  maxValue = getUpperRoundNumber(value: maxValue!, gridStep: verticalGridStep!)
            
            if minValue! < 0 {
            
                var step: CGFloat
                
                if verticalGridStep! > 3 {
                    step = fabs(maxValue! - minValue!) / CGFloat(verticalGridStep! - 1)
                } else {
                    step = max(fabs(maxValue! - minValue!) / 2, max(fabs(minValue!), fabs(maxValue!)))
                }
                
                step = getUpperRoundNumber(value: step, gridStep: verticalGridStep!)
                
                var newMin: CGFloat
                var newMax: CGFloat

                if fabs(minValue!) > fabs(maxValue!) {
                    let m = ceil(fabs(minValue!) / step)
                   
                    newMin = step * m * (minValue! > 0 ? 1 : -1)
                    newMax = step * (CGFloat(verticalGridStep!) - m) * (maxValue! > 0 ? 1 : -1)
                } else {
                    let m = ceil(fabs(maxValue!) / step)
                    
                    newMax = step * m * (maxValue! > 0 ? 1 : -1)
                    newMin = step * (CGFloat(verticalGridStep!) - m) * (minValue! > 0 ? 1 : -1)
                }
                
                if(minValue! < newMin) {
                    newMin -= step
                    newMax -=  step
                }
                
                if(maxValue! > newMax + step) {
                    newMin += step
                    newMax += step
                }
                
                minValue = newMin
                maxValue = newMax
                
                if(maxValue! < minValue!) {
                    let tmp = maxValue!
                    maxValue = minValue
                    minValue = tmp
                }
                
            }
        }
    }
    
    func getUpperRoundNumber(value: CGFloat, gridStep: Int) -> CGFloat {
        if value <= 0.0 {
            return 0.0
        }
        
        let logValue = log10f(Float(value))
        let scale = powf(10.0, floorf(logValue))
        var n = ceil(value / CGFloat(scale * 4))
        
        let tmp = Int(n) % gridStep
        
        if tmp != 0 {
            n += CGFloat(gridStep - tmp)
        }
        
        return n * CGFloat(scale) / 4.0
    }
    
    func setGridStep(gridStep: Int) {
        verticalGridStep = gridStep
        horizontalGridStep = gridStep
    }
    
    func getPointForData(index: Int, scale: CGFloat) -> CGPoint {
        if index < 0 || index >= dataPoints.count{
            return CGPoint.zero
        }
        
        let dataPoint = dataPoints[index].close!
        
        var properWidth = axisWidth!
        if timeRange! == .oneDay {
            properWidth = ((CGFloat(dataPoints.count) / 391.0) * axisWidth!) - margin!
        }
        
        var xDenom = CGFloat(dataPoints.count - 1)
        if xDenom == 0 { xDenom = 1 }
        
        var yDenom = maxValue! - minValue!
        if yDenom == 0 { yDenom = 0 }
        
        let pt = CGPoint(
            x: margin! + CGFloat(index) * ( properWidth / xDenom ),
            y: ( axisHeight! - (( (dataPoint - minValue!) / yDenom ) * axisHeight!) ) + margin!
        
        )
        
        return pt
        
        // for % based charts
//        var xValue = margin! + CGFloat(index) * (properWidth / CGFloat(dataPoints.count - 1))
//        let startingPoint = maxValue! / (maxValue! + fabs(minValue!))
//        
//        var yValue = (axisHeight! * startingPoint) - ((CGFloat(dataPoint) / ((maxValue! + fabs(minValue!)) * startingPoint)) * (axisHeight! * startingPoint))
//        
//        let isYNan = isnan(yValue)
//        if isYNan { yValue = 0.0 }
//        
//        let isXNan = isnan(xValue)
//        if isXNan { xValue = 0.0 }
//        
//        CGPointMake(xValue,yValue)
        
        
    }
    
    func getLinePath(scale: CGFloat, smoothing: Bool, close: Bool) -> UIBezierPath {
    
        let path = UIBezierPath()

        for i in 0 ..< dataPoints.count {
            if i > 0 {
                path.addLine(to: getPointForData(index: i, scale: scale))
            } else {
                path.move(to: getPointForData(index: i, scale: scale))
            }
        }
        
        return path
    }
    
    
    func timeLabelsForTimeFrame(_ range: ChartTimeRange) -> [String] {
    
        switch range {
        case .oneDay:
            return ["9:30am", "10", "11", "12pm", "1", "2", "3", "4"]
        case .fiveDays:
            
           let weekday = (Calendar(identifier: Calendar.Identifier.gregorian) as NSCalendar).components(.weekday, from: Date()).weekday!
           switch weekday {
           case 1:
            return ["Mon", "Tues", "Wed", "Thu", "Fri"]
           case 2:
            return ["Tues", "Wed", "Thu", "Fri", "Mon"]
           case 3:
             return ["Wed", "Thu", "Fri", "Mon", "Tues"]
           case 4:
            return ["Thu", "Fri", "Mon", "Tues", "Wed"]
           case 5:
            return ["Fri", "Mon", "Tues", "Wed", "Thu"]
           case 6:
            return ["Mon", "Tues", "Wed", "Thu", "Fri"]
           case 7:
            return ["Mon", "Tues", "Wed", "Thu", "Fri"]
           default: ()
           }
        case .tenDays:
            let weekday = (Calendar(identifier: Calendar.Identifier.gregorian) as NSCalendar).components(.weekday, from: Date()).weekday!
            switch weekday {
                //sunday
            case 1:
                return ["Mon", "Wed", "Fri", "Mon", "Wed", "Fri"]
            case 2:
                return ["Wed", "Fri", "Mon", "Wed", "Fri", "Mon"]
            case 3:
                return ["Wed", "Fri", "Mon", "Wed", "Fri", "Tues"]
            case 4:
                return ["Fri", "Mon", "Wed", "Fri", "Mon", "Wed"]
            case 5:
                return ["Wed", "Mon", "Wed", "Fri", "Tues", "Thu"]
            case 6:
                return ["Mon", "Wed", "Fri", "Mon", "Wed", "Fri"]
                //saturday
            case 7:
                return ["Mon", "Wed", "Fri", "Mon", "Wed", "Fri"]
            default: ()
            }
        case .oneMonth:
            
            let fmt = DateFormatter()
            fmt.dateFormat = "dd MMM"
            let offset = Double(-6*24*60*60)
            let start = Date()
            let fifthString = fmt.string(from: start.addingTimeInterval(offset))
            let fourthString = fmt.string(from: start.addingTimeInterval(offset * 2))
            let thirdString = fmt.string(from: start.addingTimeInterval(offset * 3))
            let secondString = fmt.string(from: start.addingTimeInterval(offset * 4))
            let firstString = fmt.string(from: start.addingTimeInterval(offset * 5))
            
            return[firstString, secondString, thirdString, fourthString, fifthString, ""]
        case .threeMonths:
            let fmt = DateFormatter()
            fmt.dateFormat = "dd MMM"
            let offset = Double(-15*24*60*60)
            let start = Date()
            let fifthString = fmt.string(from: start.addingTimeInterval(offset))
            let fourthString = fmt.string(from: start.addingTimeInterval(offset * 2))
            let thirdString = fmt.string(from: start.addingTimeInterval(offset * 3))
            let secondString = fmt.string(from: start.addingTimeInterval(offset * 4))
            let firstString = fmt.string(from: start.addingTimeInterval(offset * 5))
            
            return[firstString, secondString, thirdString, fourthString, fifthString, ""]
        case .oneYear:
            let fmt = DateFormatter()
            fmt.dateFormat = "MMM"
            let offset = Double(-80*24*60*60)
            let start = Date()
            let fifthString = fmt.string(from: start.addingTimeInterval(offset))
            let fourthString = fmt.string(from: start.addingTimeInterval(offset * 2))
            let thirdString = fmt.string(from: start.addingTimeInterval(offset * 3))
            let secondString = fmt.string(from: start.addingTimeInterval(offset * 4))
            let firstString = fmt.string(from: start.addingTimeInterval(offset * 5))
            
            return[firstString, secondString, thirdString, fourthString, fifthString, ""]

        case .fiveYears:
            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy"
            let offset = Double(-365*24*60*60)
            let start = Date()
            let fifthString = fmt.string(from: start.addingTimeInterval(offset))
            let fourthString = fmt.string(from: start.addingTimeInterval(offset * 2))
            let thirdString = fmt.string(from: start.addingTimeInterval(offset * 3))
            let secondString = fmt.string(from: start.addingTimeInterval(offset * 4))
            let firstString = fmt.string(from: start.addingTimeInterval(offset * 5))
            
            return[firstString, secondString, thirdString, fourthString, fifthString, ""]
        }
        return []
    }
}
















