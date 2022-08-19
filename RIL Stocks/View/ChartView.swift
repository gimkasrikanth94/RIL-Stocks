//
//  ChartView.swift
//  RIL Stocks
//
//  Created by Srikanth Gimka on 19/08/22.
//

import SwiftUI
import SwiftUICharts


struct ChartView: View {


    let data: StackedBarChartData

    var body: some View {
        ScrollView(.horizontal){
            StackedBarChart(chartData: data)
            .touchOverlay(chartData: data)
            .xAxisGrid(chartData: data)
            .xAxisLabels(chartData: data)
            .yAxisLabels(chartData: data)
            .headerBox(chartData: data)
            .legends(chartData: data, columns: [GridItem(.flexible()), GridItem(.flexible())])
            .id(data.id)
            .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 500, maxHeight: 600, alignment: .center)
            .padding(.horizontal)
        }

        
        
    }

}


