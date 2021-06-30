//
//  MoviesViewController.m
//  Flix
//
//  Created by Rigre Reinier Garciandia Larquin on 6/23/21.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Movie.h"
#import "APIManager.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *movies;
@property (nonatomic, strong) NSMutableArray *filteredMovies;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchBar.delegate = self;
    
    [self.activityIndicator startAnimating];
    self.activityIndicator.layer.zPosition = 1;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    
//    [self.tableView addSubview:self.refreshControl];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void) fetchMovies {
    self.tableView.hidden = true;
    
    APIManager *manager = [APIManager new];
    [manager fetchNowPlaying:^(NSArray *movies, NSError *error) {
        self.movies = self.filteredMovies = movies;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
        self.tableView.hidden = false;
    }];
}

- (void) addNetworkErrorAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create a cancel action
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle cancel response here. Doing nothing will dismiss the view.
        NSLog(@"Try again");
        [self viewDidLoad];
        }];
    
    // add the cancel action to the alertController
    [alert addAction:tryAgainAction];
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    Movie *movie = self.filteredMovies[indexPath.row];
    
    cell.movie = self.movies[indexPath.row];
    [cell setMovie:movie];
    
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *movie, NSDictionary *bindings) {
    
            return [movie[@"title"] localizedCaseInsensitiveContainsString:searchText];
            
        }];
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredMovies = self.movies;
    }
    
    [self.tableView reloadData];
 
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    
    self.filteredMovies = self.movies;
    [self.tableView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    
    Movie *movie = self.filteredMovies[indexPath.row];
    
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    
    detailsViewController.movie = movie;
    
    NSLog(@"Tapping on a movie");
}



@end
