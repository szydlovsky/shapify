//
//  RecognizeSongWidget.swift
//  RecognizeSongWidget
//
//  Created by Alex on 29/01/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
}

struct RecognizeSongWidgetEntryView : View {
    
    var entry: Provider.Entry

    private static let deeplinkURL: URL = URL(string: "widget-deeplink://")!

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Spacer()
                Image("shapifyLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width, height: geo.size.height*0.75,
                           alignment: .top)
                    .widgetURL(RecognizeSongWidgetEntryView.deeplinkURL)
                Text("Tap To Recognize")
                    .font(Font.custom("Spoof-Regular", size: 16))
                    .foregroundColor(Color(red: 0.08, green: 0.30, blue: 0.33))
                Spacer()
            }
        }
            
    }
}

struct RecognizeSongWidget: Widget {
    let kind: String = "RecognizeSongWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RecognizeSongWidgetEntryView(entry: entry)
                .background(Color(red: 0.89, green: 0.93, blue: 0.86))
        }
        .configurationDisplayName("Recognize Song Widget")
        .description("Tap To Recognize")
    }
}

struct RecognizeSongWidget_Previews: PreviewProvider {
    static var previews: some View {
        RecognizeSongWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
