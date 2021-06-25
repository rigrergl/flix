//
//  TrailerViewController.m
//  Flix
//
//  Created by Rigre Reinier Garciandia Larquin on 6/24/21.
//

#import "TrailerViewController.h"
#import "WebKit/Webkit.h"

@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *baseYoutubeURL = @"https://www.youtube.com/watch?v=";
    NSString *keyString = @"SUXWAEX2jlg";
    
    // Do any additional setup after loading the view.
    NSLog(@"Movie ID: %d", self.movie_id);
    
    // As a property or local variable
    NSString *urlString = [NSString stringWithFormat:@"%@%@", baseYoutubeURL, keyString];
//    NSString *urlString = @"https://www.dropbox.com/terms?mobile=1";
    
    // Convert the url String to a NSURL object.
    NSURL *url = [NSURL URLWithString:urlString];

    // Place the URL in a URL Request.
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:10.0];
    // Load Request into WebView.
    [self.webView loadRequest:request];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
