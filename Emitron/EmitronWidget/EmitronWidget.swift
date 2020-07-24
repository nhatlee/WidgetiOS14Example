// Copyright (c) 2020 Razeware LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
// distribute, sublicense, create a derivative work, and/or sell copies of the
// Software in any work that is designed, intended, or marketed for pedagogical or
// instructional purposes related to programming, coding, application development,
// or information technology.  Permission for such use, copying, modification,
// merger, publication, distribution, sublicensing, creation of derivative works,
// or sale is expressly withheld.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import WidgetKit
import SwiftUI
import Intents

extension FileManager {
  static func sharedContainerURL() -> URL {
    return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: "group.emitron.contents"
    )!
  }
}

let snapshotEntry = WidgetContent(name: "iOS Concurrency with GCD and Operations",
  cardViewSubtitle: "iOS & Swift",
  descriptionPlainText: """
  Learn how to add concurrency to your apps! \
  Keep your app’s UI responsive to give your \
  users a great user experience.
  """,
  releasedAtDateTimeString: "Jun 23 2020 • Video Course (3 hrs, 21 mins)")

//struct Provider: TimelineProvider {
//  public typealias Entry = WidgetContent
//
//  public func snapshot(with context: Context, completion: @escaping (Entry) -> ()) {
//    let entry = snapshotEntry
//    completion(entry)
//  }
//
//  func readContents() -> [Entry] {
//    var contents: [WidgetContent] = []
//    let archiveURL = FileManager.sharedContainerURL().appendingPathComponent("contents.json")
//    print(">>> \(archiveURL)")
//
//    let decoder = JSONDecoder()
//    if let codeData = try? Data(contentsOf: archiveURL) {
//      do {
//        contents = try decoder.decode([WidgetContent].self, from: codeData)
//      } catch {
//        print("Error: Can't decode contents")
//      }
//    }
//    return contents
//  }
//
//  public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//    var entries = readContents()
//
//    // Generate a timeline by setting entry dates interval seconds apart,
//    // starting from the current date.
//    let currentDate = Date()
//    let interval = 5
//    for index in 0 ..< entries.count {
//      entries[index].date = Calendar.current.date(byAdding: .second,
//        value: index * interval, to: currentDate)!
//    }
//
//    let timeline = Timeline(entries: entries, policy: .atEnd)
//    completion(timeline)
//  }
//}

struct PlaceholderView : View {
  var body: some View {
    EntryView(model: snapshotEntry)
  }
}

//@main
//struct EmitronWidget: Widget {
//  private let kind: String = "EmitronWidget"
//
//  public var body: some WidgetConfiguration {
//    StaticConfiguration(kind: kind, provider: Provider(), placeholder: PlaceholderView()) { entry in
//      EntryView(model: entry)
//    }
//    .configurationDisplayName("RW Tutorials")
//    .description("See the latest video tutorials.")
//    .supportedFamilies([.systemMedium])
//  }
//}

struct Provider: IntentTimelineProvider {
  public typealias Entry = WidgetContent

  public func snapshot(for configuration: TimelineIntervalIntent, with context: Context, completion: @escaping (Entry) -> ()) {
    let entry = snapshotEntry
    completion(entry)
  }

  func readContents() -> [Entry] {
    var contents: [WidgetContent] = []
    let archiveURL = FileManager.sharedContainerURL().appendingPathComponent("contents.json")
    print(">>> \(archiveURL)")

    let decoder = JSONDecoder()
    if let codeData = try? Data(contentsOf: archiveURL) {
      do {
        contents = try decoder.decode([WidgetContent].self, from: codeData)
      } catch {
        print("Error: Can't decode contents")
      }
    }
    return contents
  }

  public func timeline(for configuration: TimelineIntervalIntent, with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries = readContents()
    let interval = configuration.interval as! Int

    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for index in 0 ..< entries.count {
      entries[index].date = Calendar.current.date(byAdding: .second, value: index * interval, to: currentDate)!
    }

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

@main
struct EmitronWidget: Widget {
  private let kind: String = "EmitronWidget"

  public var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: TimelineIntervalIntent.self, provider: Provider(), placeholder: PlaceholderView()) { entry in
      EntryView(model: entry)
    }
    .configurationDisplayName("RW Tutorials")
    .description("See the latest video tutorials.")
    .supportedFamilies([.systemMedium])
  }
}
