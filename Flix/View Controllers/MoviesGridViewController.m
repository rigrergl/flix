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

@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSArray* test = @[@520763, @337404, @508943];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:test forKey:@"favoriteIDs"];

    
    NSArray* favoriteIDs = [defaults arrayForKey:@"favoriteIDs"];
    self.favoriteIDs = favoriteIDs;

    
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
//                   for(id currentTovie in self.movies) {
//                       NSLog(@"ID: %@", movie[@"id"]);
//                       NSInteger movieID =(NSInteger)508943;
//                       NSInteger fetchedMovieID = (NSInteger)[movie[@"id"] integerValue];
//
//                       NSLog(@"%ld %ld", fetchedMovieID, movieID);
//
//                       if(fetchedMovieID == movieID){
//                           NSLog(@"Returned true");
//                           return true;
//                       }
//                   }
//                   return false;
                   
                   for (NSNumber* favID in self.favoriteIDs) {
//                       NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                       
                       NSNumber* fetchedMovieID = movie[@"id"];
//                       if([favID isEqualToString:currentMovieID]){
                       if([favID integerValue] == [fetchedMovieID integerValue]){
                           return true;
                       }
                   }
                   return false;
                   
//                   NSInteger movieID =(NSInteger)423108;
//                   NSInteger fetchedMovieID = (NSInteger)[movie[@"id"] integerValue];
//
//                   NSLog(@"%ld %ld", fetchedMovieID, movieID);
//
//                   if(fetchedMovieID == movieID){
//                        NSLog(@"Returned true");
//                        return true;
//                   } else {
//                       return false;
//                   }
               }];
               
               self.movies = [self.movies filteredArrayUsingPredicate:predicate];
//               NSLog(@"%@", self.movies);
            
               
               [self.collectionView reloadData];
           }
//        [self.refreshControl endRefreshing];
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
