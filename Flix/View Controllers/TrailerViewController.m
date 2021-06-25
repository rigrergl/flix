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
@property (strong, nonatomic) NSString* keyString;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *beginningString = @"https://api.themoviedb.org/3/movie/";
    NSString *endingString = @"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld%@", beginningString, self.movie_id, endingString]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSArray *results = dataDictionary[@"results"];
               NSDictionary *resultDictionary = results[0];
               self.keyString = resultDictionary[@"key"];
               [self loadYoutube];
           }
       }];
    [task resume];
}

- (void) loadYoutube {
    NSString *baseYoutubeURL = @"https://www.youtube.com/watch?v=";
    
    // As a property or local variable
    NSString *urlString = [NSString stringWithFormat:@"%@%@", baseYoutubeURL, self.keyString];
//    NSString *urlString = @"https://www.dropbox.com/terms?mobile=1";
    
    // Convert the url String to a NSURL object.
    NSURL *youtubeURL = [NSURL URLWithString:urlString];

    // Place the URL in a URL Request.
    NSURLRequest *youtubeRequest = [NSURLRequest requestWithURL:youtubeURL
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:10.0];
    // Load Request into WebView.
    [self.webView loadRequest:youtubeRequest];
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
