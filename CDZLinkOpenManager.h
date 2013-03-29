#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CDZBrowser) {
    CDZBrowserSafari = 0,
    CDZBrowserChrome,
    CDZBrowserOnePassword,
    CDZNumBrowsers
};

@interface CDZLinkOpenManager : NSObject

/**
 * Returns YES if the given browser is available on this device.
 */
+ (BOOL)browserAvailable:(CDZBrowser)browser;

/**
 * Returns the user's selected default browser.
 */
+ (CDZBrowser)selectedBrowser;

/**
 * Sets the user's selected default browser.
 */
+ (void)setSelectedBrowser:(CDZBrowser)browser;

/**
 * Opens the given URL.
 *
 * If HTTP or HTTPS, uses the defaut browser.
 */
+ (void)openURL:(NSURL *)url;
+ (void)openURLString:(NSString *)urlString;

/**
 * Returns the human-friendly name for the given browser.
 */
+ (NSString *)nameForBrowser:(CDZBrowser)browser;

@end
