//
//  ContentView.swift
//  Stocks App
//
//  Created by Antonio Gormley on 14/08/2021.
//

import SwiftUI

struct LineGraph:Shape {
    ///Normalised data points
    var dataPoints: [CGFloat]
    func path(in rect: CGRect) -> Path {
        
        func point(at ix:Int) -> CGPoint {
            let point = dataPoints[ix]
            let x = rect.width * CGFloat(ix) / CGFloat(dataPoints.count - 1)
            let y = (1 - point) * rect.height
            return CGPoint(x: x, y: y)
        }
        
        return Path { p in
            ///Bad cases
            guard dataPoints.count > 1 else {
                return
            }
            let start = dataPoints[0]
            p.move(to: CGPoint(x: 0, y: (1 - start) * rect.height))
            
            for idx in dataPoints.indices {
                p.addLine(to: point(at: idx))
            }
        }
    }
    
    
}

struct ContentView: View {
    var body: some View {
        LineGraph(dataPoints: ChartMockData.oneMonth.normalised)
            .stroke(Color.blue)
            .frame(width: 400, height: 300)
            .border(Color.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Array where Element == CGFloat {
    ///Return the elements of sequence normalised
    var normalised:[CGFloat] {
        if let min = self.min(), let max = self.max() {
            return self.map {
                ($0 - min) / (max - min)
            }
        }
        return []
    }
}
