//
//  ViewController.swift
//  DTList
//
//  Created by MrDzmitry on 16.01.2022.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func buttonDidPress(sender: NSButton) {
        let listOfVolumes = self.getListOfVolumes()
        var result = [(String, [String])]()
        
        listOfVolumes.forEach { (volumeURL:URL) in
            let t = try! self.getListOfTorrentsInDirectory(directoryURL: volumeURL)
            result.append((volumeURL.absoluteString, t))
        }
        
        result.forEach({
            print($0.0)
            $0.1.forEach({
                print(" \($0)")
            })
        })
//        Task {
//            let volumesList: [URL] = await self.getListOfVolumes()
//
//            async let t1 = self.getListOfTorrentsInVolume(volumeURL: volumesList[0])
//
//            let r1 = try await t1
//            print("\(r1)")
//
////            var tasks = [Task<[URL], Error>]()
////            volumesList.forEach({ iUrl in
////                let task = Task {
////                    try await self.getListOfTorrentsInVolume(volumeURL: iUrl)
////                }
////
////                tasks.append(task)
////            })
////
////            await tasks
//
////            let resultList: [URL] = try await withThrowingTaskGroup(of: [URL].self) { group in
////                for oneVolume in volumesList {
////                    group.addTask {
////                        try await self.getListOfTorrentsInVolume(volumeURL: oneVolume)
////                    }
////                }
////
////                var resultList = [URL]()
////                for try await urls in group {
////                    resultList.append(contentsOf: urls)
////                }
////
////                return resultList
////            }
////            print("\(resultList)")
//        }
    }
    
    private func getListOfVolumes() -> [URL] {
        let keys = [URLResourceKey.volumeNameKey, URLResourceKey.volumeIsRemovableKey, URLResourceKey.volumeIsEjectableKey]
        let pathURLs = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: keys, options: []) ?? []
        return pathURLs.filter({ $0.absoluteString.hasPrefix("file:///Volumes/") })
    }
    
    private func getListOfTorrentsInDirectory(directoryURL: URL) throws -> [String] {
        let resourceKeys = Set<URLResourceKey>([.nameKey, .isDirectoryKey])
        let directoryEnumerator = FileManager().enumerator(at: directoryURL, includingPropertiesForKeys: Array(resourceKeys), options: .skipsHiddenFiles)!
         
        var torrentFileNamesList = [String]()
        let directoryURLLength = directoryURL.absoluteString.count
        for case let fileURL as URL in directoryEnumerator {
            let resourceValues = try fileURL.resourceValues(forKeys: resourceKeys)
            guard let isDirectory = resourceValues.isDirectory,
                let fileName = resourceValues.name
                else {
                    continue
            }
            
            if isDirectory {
                continue
            }
            
            if fileName.hasSuffix(".torrent") == false {
                continue
            }
            
            let s = String(fileURL.absoluteString.removingPercentEncoding!.dropFirst(directoryURLLength))
            torrentFileNamesList.append(s)
            
//            if isDirectory {
//                if name == "_extras" {
//                    directoryEnumerator.skipDescendants()
//                }
//            } else {
//                fileURLs.append(fileURL)
//            }
        }
         
        return torrentFileNamesList
    }

}

