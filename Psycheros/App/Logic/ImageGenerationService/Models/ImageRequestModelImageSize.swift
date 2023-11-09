extension ImageRequestModel {
    enum ImageSize: CaseIterable {
        case size1024x1024,
             size1152x896,
             size1216x832,
             size1344x768,
             size1536x640,
             size640x1536,
             size768x1344,
             size832x1216,
             size896x1152
        
        var width: Int {
            switch self {
            case .size1024x1024: 1024
            case .size1152x896: 1152
            case .size1216x832: 1216
            case .size1344x768: 1344
            case .size1536x640: 1536
            case .size640x1536: 640
            case .size768x1344: 768
            case .size832x1216: 832
            case .size896x1152: 896
            }
        }
        
        var height: Int {
            switch self {
            case .size1024x1024: 1024
            case .size1152x896: 896
            case .size1216x832: 832
            case .size1344x768: 768
            case .size1536x640: 640
            case .size640x1536: 1536
            case .size768x1344: 1344
            case .size832x1216: 1216
            case .size896x1152: 1152
            }
        }
    }
}
