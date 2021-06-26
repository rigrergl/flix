//
//  DetailsViewController.m
//  Flix
//
//  Created by Rigre Reinier Garciandia Larquin on 6/23/21.
//

#import "DetailsViewController.h"
#import "TrailerViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (nonatomic)BOOL isFavorite;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Detail View Loaded");
    
    
    //setting up poster
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    
    self.posterView.image = nil;
    [self.posterView setImageWithURL:posterURL ];
    
    //setting up backdrop
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    
    self.backdropView.image = nil;
    [self.backdropView setImageWithURL:backdropURL ];
    
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    
    //setting heart button
    [self updateFavorite];
    UIImage * unselectedImage = [UIImage systemImageNamed:@"heart"];
    UIImage * selectedImage = [UIImage systemImageNamed:@"heart.fill"];
    if (!self.isFavorite) {
        [self.favoriteButton setImage:unselectedImage forState:UIControlStateNormal];
        [self.favoriteButton setSelected:NO];
        
    } else {
        [self.favoriteButton setImage:selectedImage forState:UIControlStateSelected];
        [self.favoriteButton setSelected:YES];
    }
    
    
}

- (void) updateFavorite {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray* favoriteIDs = [defaults arrayForKey:@"favoriteIDs"];
    
    NSNumber* movieID = self.movie[@"id"];
    for (NSNumber * favID in favoriteIDs) {
        if([movieID integerValue] == [favID integerValue]) {
            self.isFavorite = true;
            return;
        }
    }
    self.isFavorite = false;
    return;
}

- (IBAction)onTapPoster:(id)sender {
    NSLog(@"Tap");
    [self performSegueWithIdentifier:@"webSegue" sender:nil];
}

- (IBAction)favoriteButtonClicked:(UIButton *)sender {
    //    let homeImage = UIImage(systemName: "house", withConfiguration: homeSymbolConfiguration)
    
    //    UIImage * homeImage = [UIImage systemImageNamed:@"house"];
    
    NSLog(@" Selected State: %d", sender.isSelected);
    
    UIImage * unselectedImage = [UIImage systemImageNamed:@"heart"];
    UIImage * selectedImage = [UIImage systemImageNamed:@"heart.fill"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    if ([sender isSelected]) {
        [sender setImage:unselectedImage forState:UIControlStateNormal];
        [sender setSelected:NO];
        
        NSArray* favoriteIDs = [defaults arrayForKey:@"favoriteIDs"];
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSNumber* currentID, NSDictionary *bindings) {
            return currentID != self.movie[@"id"];
        }];
        
        favoriteIDs = [favoriteIDs filteredArrayUsingPredicate:predicate];
        NSLog(@"New Favorite IDs: %@", favoriteIDs);
        [defaults setObject:favoriteIDs forKey:@"favoriteIDs"];
        [defaults synchronize];
        
        //            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //            [defaults setObject:test forKey:@"favoriteIDs"];
    } else {
        [sender setImage:selectedImage forState:UIControlStateSelected];
        [sender setSelected:YES];
        
        NSArray* favoriteIDs = [defaults arrayForKey:@"favoriteIDs"];
        NSMutableArray* mutableArray = [favoriteIDs mutableCopy];
        if(mutableArray == nil)
            mutableArray = [[NSMutableArray alloc] init];
        
        [mutableArray addObject:self.movie[@"id"]];
        
        NSLog(@"%@", self.movie[@"id"]);
        NSLog(@"New Favorite IDs: %@", mutableArray);
        
        
        [defaults setObject:mutableArray forKey:@"favoriteIDs"];
        [defaults synchronize];
        
    }
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    TrailerViewController *trailerViewController = [segue destinationViewController];
    
    NSInteger movie_id = [self.movie[@"id"] integerValue];
    trailerViewController.movie_id = movie_id;
}


@end
