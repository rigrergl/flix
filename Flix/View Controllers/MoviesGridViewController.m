//
//  MoviesGridViewController.m
//  Flix
//
//  Created by Rigre Reinier Garciandia Larquin on 6/24/21.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray* favoriteIDs;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MoviesGridViewController

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"View appeared");
    [self fetchMovies];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Grid view loaded");
    
    self.refreshControl = [[UIRefreshControl alloc ] init];
    [self.collectionView insertSubview:self.refreshControl atIndex:0];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    

    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self fetchMovies];
    
    UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}


- (void) fetchMovies {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray* favoriteIDs = [defaults arrayForKey:@"favoriteIDs"];
    self.favoriteIDs = favoriteIDs;
    
    NSLog(@"%@", self.favoriteIDs);
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
//               [self addNetworkErrorAlert];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               self.movies = dataDictionary[@"results"];
               
               NSArray *favoriteMovies = [[NSArray alloc] init];
               
               NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *movie, NSDictionary *bindings) {
                   
                   for (NSNumber* favID in self.favoriteIDs) {

                       
                       NSNumber* fetchedMovieID = movie[@"id"];

                       if([favID integerValue] == [fetchedMovieID integerValue]){
                           return true;
                       }
                   }
                   return false;
                   
               }];
               
               self.movies = [self.movies filteredArrayUsingPredicate:predicate];
               [self.collectionView reloadData];
           }
        [self.refreshControl endRefreshing];
        [self.collectionView reloadData];
//        [self.activityIndicator stopAnimating];
       }];
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.item];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL ];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}



@end
