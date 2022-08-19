//
//  CandleChartView.swift
//  RIL Stocks
//
//  Created by Srikanth Gimka on 19/08/22.
//

import SwiftUI
import SwiftUICharts

struct CandleChartView: View {
        let data: RangedBarChartData

    var body: some View {
            HStack{
                
                RangedBarChart(chartData: data)
                    .touchOverlay(chartData: data, specifier: "%.0f", unit: .prefix(of: "₹"))
                    .xAxisGrid(chartData: data)
                    .yAxisGrid(chartData: data)
                    .xAxisLabels(chartData: data)
                    .yAxisLabels(chartData: data)
                    .infoBox(chartData: data)
                    .headerBox(chartData: data)
                    .legends(chartData: data, columns: [GridItem(.flexible()), GridItem(.flexible())])
                    .id(data.id)
                    .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 500, maxHeight: 600, alignment: .center)
                    .padding(.horizontal)
                }
    }
}



