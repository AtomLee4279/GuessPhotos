//
//  ViewController.m
//  GuessPhotos
//
//  Created by 李一贤 on 2018/3/21.
//  Copyright © 2018年 李一贤. All rights reserved.
//

#import "ViewController.h"
#import "AppModel.h"
@interface ViewController ()
- (IBAction)nextQuestion:(UIButton*)btn;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
@property(assign,nonatomic)int index;
@property(nonatomic,strong)NSArray* questions;
@property (weak, nonatomic) IBOutlet UILabel *page;
@property (weak, nonatomic) IBOutlet UILabel *answer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 0;
    [self.btnPhoto setImage:[UIImage imageNamed:@"1"] forState:(UIControlStateNormal)];
    self.page.text = [NSString stringWithFormat:@"%d/%ld",self.index+1,self.questions.count];
    self.answer.text = @"";
    // Do any additional setup after loading the view, typically from a nib.
}

//懒加载
-(NSArray*)questions

{
    if(_questions ==nil)
    {
        NSString* path = [[NSBundle mainBundle]pathForResource:@"questions.plist" ofType:nil];
        NSArray* dictArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray* tmpArray = [NSMutableArray array];
        for(NSDictionary*dict in dictArray)
        {
            AppModel* appmodel = [AppModel appModelWithDict:dict];
            [tmpArray addObject:appmodel];
        }
        _questions = tmpArray;
    }
    return _questions;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)nextQuestion:(UIButton*)btn {
    if(_index!=2)
    {
        self.index++;
//        NSString* index = [NSString stringWithFormat:@"%d",self.index];
        AppModel* appModel = self.questions[_index];
        [self.btnPhoto setImage:[UIImage imageNamed:appModel.icon] forState:(UIControlStateNormal)];
        self.page.text = [NSString stringWithFormat:@"%d/%ld",self.index+1,self.questions.count];
        self.answer.text = appModel.answer;
     
    }
    else
    {
        btn.enabled = NO;
    }
    
    
}
@end
