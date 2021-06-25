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
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    
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
    
    if ([sender isSelected]) {
            [sender setImage:unselectedImage forState:UIControlStateNormal];
            [sender setSelected:NO];
         } else {
            [sender setImage:selectedImage forState:UIControlStateSelected];
            [sender setSelected:YES];
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
