#import "CDZLinkOpenManager.h"

static NSString *kCDZBrowserPrefsKey = @"BVMBrowserPrefsKey"; // "BVM" for historical reasons

static NSString *kCDZBrowserNames[CDZNumBrowsers];
static NSURL *kCDZBrowserTestURLs[CDZNumBrowsers];

__attribute__((constructor)) static void __CDZBrowserConstantsInit(void)
{
    @autoreleasepool {
        kCDZBrowserNames[CDZBrowserSafari] = NSLocalizedString(@"Safari", nil);
        kCDZBrowserNames[CDZBrowserOnePassword] = NSLocalizedString(@"1Password", nil);
        kCDZBrowserNames[CDZBrowserChrome] = NSLocalizedString(@"Google Chrome", nil);

        kCDZBrowserTestURLs[CDZBrowserSafari] = [NSURL URLWithString:@"http://google.com"];
        kCDZBrowserTestURLs[CDZBrowserChrome] = [NSURL URLWithString:@"googlechrome://google.com"];
        kCDZBrowserTestURLs[CDZBrowserOnePassword] = [NSURL URLWithString:@"onepassword://search"];
    }
}

@implementation CDZLinkOpenManager

#pragma mark Browser availability

+ (BOOL)browserAvailable:(CDZBrowser)browser
{
    if (browser >= CDZNumBrowsers || browser < 0) {
        NSLog(@"Unknown browser %d in %s", browser, __PRETTY_FUNCTION__);
        return NO;
    }

    NSURL *testURL = kCDZBrowserTestURLs[browser];
    return [[UIApplication sharedApplication] canOpenURL:testURL];
}

#pragma mark Default browser management

+ (CDZBrowser)selectedBrowser {
    // note: if not set, this falls back to 0 == CDZBrowserSafari
    return [[NSUserDefaults standardUserDefaults] integerForKey:kCDZBrowserPrefsKey];
}

+ (void)setSelectedBrowser:(CDZBrowser)browser
{
    NSParameterAssert(browser >= 0 && browser < CDZNumBrowsers);

    [[NSUserDefaults standardUserDefaults] setInteger:browser forKey:kCDZBrowserPrefsKey];
}

#pragma mark URL Actions

+ (void)openURL:(NSURL *)url
{
    NSString *replacementScheme = [CDZLinkOpenManager replacementSchemeForScheme:url.scheme];

    if (replacementScheme) {
        // https://developers.google.com/chrome/mobile/docs/ios-links
        NSString *absoluteString = [url absoluteString];
        NSRange rangeForScheme = [absoluteString rangeOfString:@":"];
        NSString *urlNoScheme = [absoluteString substringFromIndex:rangeForScheme.location];
        NSString *replacedURLString = [replacementScheme stringByAppendingString:urlNoScheme];
        url = [NSURL URLWithString:replacedURLString];
    }

    [[UIApplication sharedApplication] openURL:url];
}

+ (void)openURLString:(NSString *)urlString
{
    [CDZLinkOpenManager openURL:[NSURL URLWithString:urlString]];
}

+ (NSString *)replacementSchemeForScheme:(NSString *)scheme
{
    NSString *urlScheme = [scheme lowercaseString];
    NSString *replacementScheme = nil;

    CDZBrowser selectedBrowser = [CDZLinkOpenManager selectedBrowser];
    if (selectedBrowser == CDZBrowserSafari) return nil;

    if (selectedBrowser == CDZBrowserChrome && ![CDZLinkOpenManager browserAvailable:CDZBrowserChrome]) return nil;
    if (selectedBrowser == CDZBrowserOnePassword && ![CDZLinkOpenManager browserAvailable:CDZBrowserOnePassword]) return nil;

    if ([urlScheme isEqualToString:@"http"]) {
        if (selectedBrowser == CDZBrowserOnePassword) replacementScheme = @"ophttp";
        else if (selectedBrowser == CDZBrowserChrome) replacementScheme = @"googlechrome";
    } else if ([urlScheme isEqualToString:@"https"]) {
        if (selectedBrowser == CDZBrowserOnePassword) replacementScheme = @"ophttps";
        else if (selectedBrowser == CDZBrowserChrome) replacementScheme = @"googlechromes";
    }

    return replacementScheme;
}

#pragma mark UI/Naming

+ (NSString *)nameForBrowser:(CDZBrowser)browser
{
    if (browser >= CDZNumBrowsers || browser < 0) {
        NSLog(@"Unknown browser %d in %s", browser, __PRETTY_FUNCTION__);
        return nil;
    }

    return kCDZBrowserNames[browser];
}

@end
