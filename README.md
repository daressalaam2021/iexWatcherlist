# iexWatcherlist

iexWatcherlist is a Swift iOS app for keeping track of stock watchlist using iexapis Api.

## Installation

1. donwload/clone project from Github and go to project folder using terminal (for MacOS)
2. [CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:
```bash
$ gem install cocoapods
```
Then, run the following command:
```bash
$ pod install
```
3. double click to open  `iexWatcherlist.xcworkspace`, choose an iphone simulator and click build and run button in Xcode to run the app.  

## Usage

1. Watchlist 
    *  create a new watchlist - user can click navigation bar and choose to create a watchlist by input watchlist name
    * switch watchlist - user can click navigation bar and click other watchlist to switch to a different watchlist 
    * remove a existing watchlist - user can click navigation bar left trash icon to remove current watchlist
    * add new symbols to current watchlist - user can click navigation bar right addition icon to present search bar view and add symbols through clicking plus icon on certain symbol
    * remove an existing symbol from current watchlist - user can swipe left or right on watchlist collection view's row to remove certain symbols from watchlist 
    * current watchlist keeps update quotes every 5 seconds
    * watchlists keep data consistence locally by CoreData

2. Stock Detail
    * user can view single stock detail view by click on watchlist collection view, a modal half screen view will be presented
    * besides normal bid/ask/latest data, a historical prices of 30 days will be presented in line chart implemented with Framework [Charts](https://github.com/danielgindi/Charts)
    * stock prices will be updated every 5 seconds as well 

3. Search Stocks
    * the search is using tastywork's API to find symbols with keywords
    
4. Built with Xcode 12.2, Support iOS 13.0+ and dark mode

## Unit Testing
unit tests focus on data model decoding includes `Symbol`, `Quote` and `MarketBatch`. To run the test, find sixth icon on left side bar and click right button on row `iexWatcherlistTests`
