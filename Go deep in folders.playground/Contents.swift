import Cocoa

public extension NSFont {
    static func read(from path: String, size: CGFloat) throws -> NSFont {
        print ("PATH", path)
        guard let dataProvider = CGDataProvider(filename: path) else {
            throw NSError(domain: "NSFont not found", code: 77, userInfo: ["fileName" : path])
        }
        print ("Data Provider", dataProvider)
        guard let fontRef = CGFont ( dataProvider ) else {
            throw NSError(domain: "NSFont not found", code: 77, userInfo: ["fileName" : path])
        }
        print ("Font ref", fontRef)
        return CTFontCreateWithGraphicsFont(fontRef, size, nil, nil);
    }
}
func openDocument(_ sender:Any) {
    let openPanel = NSOpenPanel()
    openPanel.allowsMultipleSelection = true
    openPanel.canChooseDirectories = true
    openPanel.canCreateDirectories = false
    openPanel.canChooseFiles = true
    openPanel.begin { (result) -> Void in
        if result == NSApplication.ModalResponse.OK {
            print (openPanel.urls)
            var fonts = [NSFont]()
            for url in openPanel.urls {
                var isDirectory: ObjCBool = ObjCBool(false)
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) {
                    print ("url \(url) is folder")
                    
                    do {
                        if let files = try? fileManager.contentsOfDirectory(atPath: url.path) {
                            for file in files {
                                let filePath = url.path + "/" + file
                                if let font = try? NSFont.read(from: filePath, size: 12) {
                                    fonts.append(font)
                                }
                            }
                        }
                    }
                } else {
                    print ("url \(url) is file")
                    if let font = try? NSFont.read(from: url.path, size: 12) {
                        fonts.append(font)
                    }
                    
                    
                }
            }
            print (fonts)
            
        }
    }
    
}
openDocument(1)
