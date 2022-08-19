//
//  ContentView.swift
//  RIL Stocks
//
//  Created by Srikanth Gimka on 19/08/22.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    
    @State private var timeFrames = ["Day", "Weekly", "Monthly"]
    @State private var selectedTimeFrame = "Day"
    @State var barData: RangedBarChartData?
    @State var stackData: StackedBarChartData?

    var body: some View {
        NavigationView{
            VStack{
                Picker("Please choose a date", selection: $selectedTimeFrame) {
                    ForEach(timeFrames, id: \.self) {
                        Text($0)
                    }
                }
                .onChange(of: selectedTimeFrame) { tag in
                    requestAPI()
                    
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Divider()
                if let dt = stackData{
                    ChartView(data: dt)
                }else if let dt = barData{
                    CandleChartView(data: dt)
                }else{
                    ProgressView()
                    Spacer()

                }
            }
            .navigationTitle("Reliance")
            .onAppear(){
                self.requestAPI()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    
}

extension ContentView{
    
    func requestAPI(){
        var timeFrame: TimeFrame = .daily
        if selectedTimeFrame == "Day"{
            timeFrame = .daily
        }else if selectedTimeFrame == "Weekly"{
            timeFrame = .weekly
        }else if selectedTimeFrame == "Monthly"{
            timeFrame = .monthly
        }
        self.barData = nil
        self.stackData = nil
        APIService.shared.loadStockData(stock: "", timeInterval: timeFrame, outPutSize: .compact) { data in
            if let resp = data{
                var data = [String: Any]()
                switch timeFrame {
                case .daily:
                    data = (resp["Time Series (Daily)"] as? [String: Any]) ?? [:]
                case .weekly:
                    data = (resp["Weekly Time Series"] as? [String: Any]) ?? [:]
                case .monthly:
                    data = (resp["Monthly Time Series"] as? [String: Any]) ?? [:]
                }
                self.barData = self.prepareChartData(data)
//                self.stackData = self.prepareStackChartData(data)
            }
        }

    }
     func prepareChartData(_ stockData: [String: Any]) -> RangedBarChartData {
        var list = [RangedBarDataPoint]()

         for (_, priceData) in Array(stockData).sorted(by: {$0.0 < $1.0}) {

            if let data = priceData as? [String: Any] {
                _ = data["1. open"] as? String ?? ""
                let higherValue = data["2. high"] as? String ?? ""
                let lowerValue = data["3. low"] as? String ?? ""
                _ = data["4. close"] as? String ?? ""
                _ = data["5. volume"] as? String ?? ""
                

                list.append( RangedBarDataPoint(lowerValue: lowerValue.toDouble() , upperValue: higherValue.toDouble() , xAxisLabel: "", description: ""))

            }

        }
         
         
         let data: RangedBarDataSet = RangedBarDataSet(dataPoints: list, legendTitle: "")

        
         let gridStyle = GridStyle(numberOfLines: 11,
                                   lineColour: Color(.lightGray).opacity(0.25),
                                   lineWidth: 1)

         let chartStyle = BarChartStyle(infoBoxPlacement: .infoBox(isStatic: false), xAxisGridStyle: gridStyle, xAxisLabelPosition: .bottom, xAxisLabelsFrom: .dataPoint(rotation: .degrees(90)), yAxisGridStyle: gridStyle, yAxisLabelPosition: .leading, yAxisNumberOfLabels: 11, baseline: .minimumWithMaximum(of: 2000), topLine: .maximum(of: 160))

         return RangedBarChartData(dataSets: data,
                                   metadata: ChartMetadata(title: "Reliance", subtitle: selectedTimeFrame),
                                   xAxisLabels: [],
                                   barStyle: BarStyle(barWidth: 0.25,
                                                      cornerRadius: CornerRadius(top: 10, bottom: 10),
                                                      colourFrom: .barStyle,
                                                      colour: ColourStyle(colours: [Color.init(red: 1, green: 0.25, blue: 0.25),Color.init(red: 1, green: 0.5, blue: 0.5)],startPoint: .bottom, endPoint: .top)),
                                   chartStyle: chartStyle)

     }
    func prepareStackChartData(_ stockData: [String: Any]) -> StackedBarChartData {
       
        let groups: [GroupingData] = [Group.low.data, Group.open.data, Group.close.data, Group.high.data]

       var list = [StackedBarDataSet]()

        for (date, priceData) in Array(stockData).sorted(by: {$0.0 < $1.0}) {

           if let data = priceData as? [String: Any] {
               let open = data["1. open"] as? String ?? ""
               let higherValue = data["2. high"] as? String ?? ""
               let lowerValue = data["3. low"] as? String ?? ""
               let close = data["4. close"] as? String ?? ""
               _ = data["5. volume"] as? String ?? ""
               
               list.append(StackedBarDataSet(dataPoints: [
                   StackedBarDataPoint(value: lowerValue.toDouble(), description: "Low", group: Group.low.data),
                   StackedBarDataPoint(value: open.toDouble(), description: "open", group: Group.open.data),
                   StackedBarDataPoint(value: close.toDouble(), description: "Close", group: Group.close.data),
                   StackedBarDataPoint(value: higherValue.toDouble(), description: "High", group: Group.high.data),

               ], setTitle: date.components(separatedBy: "-")[2]))


           }

       }
        
        let data = StackedBarDataSets(dataSets: list)

        
        return StackedBarChartData(dataSets: data, groups: groups, metadata: ChartMetadata(title: "Reliance", subtitle: ""), xAxisLabels: ["One", "Two", "Three"], barStyle: BarStyle(barWidth: 0.8), chartStyle: BarChartStyle(infoBoxPlacement: .header, xAxisGridStyle: GridStyle(numberOfLines: 5, lineColour: Color.gray.opacity(0.25)), xAxisLabelsFrom: .dataPoint(rotation: .degrees(0)), yAxisGridStyle: GridStyle(numberOfLines: 5, lineColour: Color.gray.opacity(0.25)), yAxisNumberOfLabels: 5, baseline: .zero, topLine: .maximum(of: 1600)))

    }

    

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



