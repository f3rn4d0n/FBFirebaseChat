# LFBR-SwiftLib -  📦 Commons extensions and complements to be development easier

[![Platform](https://img.shields.io/cocoapods/p/librws.svg?style=flat)](https://cocoapods.org/pods/LFBR.SwiftLib)
[![Version](https://img.shields.io/cocoapods/v/librws.svg?style=flat)](https://cocoapods.org/pods/LFBR.SwiftLib)
[![License](https://img.shields.io/cocoapods/l/librws.svg?style=flat)](http://cocoapods.org/pods/librws)
[![Build Status](https://travis-ci.org/OlehKulykov/librws.svg?branch=master)](https://travis-ci.org/f3rn4d0n/LFBR-SwiftLib)
[![Build status](https://codecov.io/gh/f3rn4d0n/LFBR-SwiftLib/branch/master/graph/badge.svg)](https://codecov.io/gh/f3rn4d0n/LFBR-SwiftLib)


### Features 🧞‍♂️
* Dismiss keyboard easy ⌨️
* Know status of your internet connection 📡
* Encrypt your messages 🧙🏽‍♂️
* Launch alert without be in a alertviewcontroller
* Manage time like timestamp ⏰
* Get size and type of your current devices 📱
* Some usual regex and his extension with strings
* Methods to create UIColors with RGB format 🎨
* No additional dependencies 👻
* Single integration with public methods
* Public extensions

### Installation with CocoaPods
#### Podfile
```ruby
pod 'LFBR.SwiftLib'
```

#### Class ReachabilityManager
An easy way to detect your internet connection and let you show your users if have internet

```Swift
//Initialize status of your internet connection
ReachabilityManager.sharedInstance.isInternetAvailable()

//Value to know if have internet connection
ReachabilityManager.sharedInstance.isInternetAvaliable
```

#### Class CommonCrypto
An easy way to encrypt your information

```Swift
let sourceData = "AES256".data(using: .utf8)!
let password = "password"
let salt = AES256Crypter.randomSalt()
let iv = AES256Crypter.randomIv()
let key = try AES256Crypter.createKey(password: password.data(using: .utf8)!, salt: salt)
let aes = try AES256Crypter(key: key, iv: iv)
let encryptedData = try aes.encrypt(sourceData)
let decryptedData = try aes.decrypt(encryptedData)

print("Encrypted hex string: \(encryptedData.base64EncodedString())")
print("Decrypted hex string: \(decryptedData.base64EncodedString())")
```

#### Class MessageObject
Let your launch easy alert view controller over all views from your window (let you work in second thread)

```Swift
//Easy implementation
MessageObject.sharedInstance.showMessage.....

// Show alert view controller with custom message, title and ok title button
///
/// - Parameters:
///   - message: Message string
///   - title: Title string
///   - okMessage: Accept string
public func showMessage(_ message:String, title:String, okMessage:String)

/// Show alert view controller with custom message, title and OK custom button
///
/// - Parameters:
///   - message: Message string
///   - title: Title string
///   - okAction: OK action behavoir
public func showMessage(_ message:String, title:String, okAction:UIAlertAction)

/// Show alert view controller with custom message, title, OK custom button and Cancel custom button
///
/// - Parameters:
///   - message: Message string
///   - title: Title string
///   - okAction: OK action behavoir
///   - cancelAction: Cancel action behavoir
public func showMessage(_ message:String, title:String, okAction:UIAlertAction, cancelAction:UIAlertAction)

/// Show alert view controller with custom message, title, OK custom button and Cancel title button
///
/// - Parameters:
///   - message: Message string
///   - title: Title string
///   - okAction: OK action behavoir
///   - cancelMessage: Cancel string
public func showMessage(_ message:String, title:String, okAction:UIAlertAction, cancelMessage:String)

/// Show alert view controller with a textview instead of this
///
/// - Parameters:
///   - message: Message string
///   - title: Title string
///   - okMessage: Accept string
///   - cancelMessage: Cancel string
///   - textPlaceHolder: Default string for your textview
///   - completion: Function to excecute after any button was clicked
public func showMessageWithTextView(_ message:String, title:String, okMessage:String, cancelMessage:String, textPlaceHolder:String, completion:@escaping(String) ->Void)
```

#### Classes for iPhone Size
```Swift
//Return kind of iPhone size (IPHONE_4, IPHONE_5, IPHONE_6, IPHONE_6_PLUS, IPHONE_X, IPHONE_UNKNOWN)
var IPHONE_DEVICE: iPhoneDevices
```

#### Class AlertPickerSelectorViewController
Easy implementation of picker selected which appear like modal view controller

```Swift
public protocol AlertPickerDelegate{
    func dateSelected(_ dateSelected: Date, andTag: Int)
}
```

#### Extension for `UIWindow`
```Swift
/// Get top visible view controller
///
/// - Returns: Top view controller
func visibleViewController() -> UIViewController?
```

#### Extension for `UIViewController`
```Swift
/
/// Remove keyboard when tap over any part of windows
func hideKeyboardWhenTappedAround()

/// Remove keyboard when tap over any part of selected view
func hideKeyboardWhenTappedIn(currentView: UIView)

/// Dismiss keyboard
@objc func dismissKeyboard()

/// Get keyboard height
///
/// - Returns: Keyboard height
func  heightKeyboard() -> CGFloat
```

#### Extension for `Int`
```Swift
/// Transform current int value to time representation by offset
///
/// - Returns: Date representation
func getDateByOffset() -> Date
```

#### Extension for `Double` and `Float`
```Swift
/// Return string representation with custom decimals and decimal separator
///
/// - Parameters:
///   - fractionDigits: number of digits after dot
///   - customDecimalSeparator: custom decimal separator, by default is dot ('.')
/// - Returns: String representation
func formatWithFractionDigits(_ fractionDigits: Int, customDecimalSeparator: String? = ".")
```

#### Extension for `UIColor`
```Swift
/// UIColor by RGB formtar
///
/// - Parameter rgb: RGB color with hex representation
convenience init(rgb: Int)

/// UIColor by red, green and blue values in interval to 0 to 255 representation
///
/// - Parameters:
///   - red: representation beetween 0 to 255
///   - green: representation beetween 0 to 255
///   - blue: representation beetween 0 to 255
convenience init(red: Int, green: Int, blue: Int)
```

#### Extension for `Date`
```Swift
/// Returns the amount of years from another date
func years(from date: Date) -> Int

/// Returns the amount of months from another date
func months(from date: Date) -> Int

// Returns the amount of weeks from another date
func weeks(from date: Date) -> Int

/// Returns the amount of days from another date
func days(from date: Date) -> Int

/// Returns the amount of hours from another date
func hours(from date: Date) -> Int

/// Returns the amount of minutes from another date
func minutes(from date: Date) -> Int

/// Returns the amount of seconds from another date
func seconds(from date: Date) -> Int

/// Returns the amount of nanoseconds from another date
func nanoseconds(from date: Date) -> Int

/// Returns the a custom time interval description from another date
func offset(from date: Date) -> String

/// Return yyy MMM dd HH:mm from current date
///
/// - Returns: date as descriptive string
func getTimeWithYYYMMMDDHHmmFormat() -> String

/// Return dd MMM yyy HH:mm from current date
///
/// - Returns: date as descriptive string
func getTimeWithDDMMMYYYHHmmFormat() -> String

/// Add some days to current date
///
/// - Parameter days: days to add to your current date
/// - Returns: date as dd-MMM format with
func getLeftDaysFrom(days:Int) -> String

/// Return date as string
///
/// - Parameter format: formate descriptio
/// - Returns: date as descriptive string
func getTimeBy(format: String) -> String

/// Transform current date value to int representation by offset
///
/// - Returns: Int64 representation
func getTimeStamp() -> Int64
```
#### Extension for `String`
```Swift
/// String representation by urlQueryAllowed
///
/// - Returns: string representation validated to url encode
func encodeUrl() -> String?

/// Decode url to get friendly string
///
/// - Returns: string decoded
func decodeUrl() -> String?

/// Check if your current string can be used like URL
///
/// - Returns: Validate if current string is URL
func isURL () -> Bool

/// Check if your current string can be used like email
///
/// - Returns: Validate if your string is an email
func isEmail() -> Bool

/// Check if your current string can be used like number
///
/// - Returns: Validate if your string is a number
func isNumber() -> Bool

/// Transform your current string to Float with 2 decimals, if your string doesn't have valid format then your response will be 0
///
/// - Returns: Float representation
func toFloat(_ localeIdentifier: String? = nil) -> Float

/// Integer reprentation of your current string, if your string doesn't have valid format then your response will be 0
var int : Int

/// Transform your current string to NSAttributedString, changing numbers to NumberFormatter
///
/// - Returns: NSAttributedString with number formatter
func sliderAttributeString() -> NSAttributedString
```

#### Extension for `NSString`
```Swift
/// Transform your current string to NSAttributedString, changing fonts from your seleted array of strings
///
/// - Parameters:
///   - boldPartsOfString: Array to strings to need his font changed
///   - font: Font for all your string
///   - boldFont: Font for your strings selected
/// - Returns: NSAttributedString with string font changed
func getdBoldedText(boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!) -> NSAttributedString
```





### License
---------

MIT License

Copyright (c) 2019 Luis Fernando Bustos Ramírez <lufe.bura@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
