function xcodeclean --description "Cleans XCode derive data and caches"
    rm -frd ~/Library/Developer/Xcode/DerivedData/*
    rm -frd ~/Library/Caches/com.apple.dt.Xcode/*
end