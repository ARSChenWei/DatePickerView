//
//  MyCollectionVliew.m
//  CameraAlone
//
//  Created by 陈威 on 16/5/6.
//  Copyright © 2016年 ZiGuangMeiShiYun. All rights reserved.
//

#import "MyCollectionVliew.h"
#import "AloneCollectionViewCell.h"
#import "MyCollectionViewCell.h"
#import <QBImagePickerController/QBImagePickerController.h>

static NSString * CWAloneCell = @"AloneCell";
static NSString * CWCollectionCell = @"CWCollCellIdentifier";

@interface MyCollectionVliew ()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate,CellDelegate>
{
    UIActionSheet * Sheet;
}

@end

@implementation MyCollectionVliew

-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.PhotoArray = [NSMutableArray arrayWithCapacity:0];

        self.delegate = self;
        self.dataSource = self;
        
        [self registerNib:[UINib nibWithNibName:@"AloneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CWAloneCell];
        [self registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CWCollectionCell];
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


#pragma mark 单选图片
-(void)AloneBtnClick
{
    NSLog(@"选择单个图片");
    
    //调用摄像头
    //    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    //    {
    //        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    //        picker.delegate = self;
    //        //是否可以编辑
    //        picker.allowsEditing = YES;
    //        //摄像头
    //        picker.sourceType = sourceType;
    //        [self presentViewController:picker animated:YES completion:nil];
    //    }
    //    else
    //    {
    //        UIAlertView * CameraAlartView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的摄像头无法打开" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //        [CameraAlartView show];
    //    }
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        //打开相册
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [[self viewController] presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        //打不开提醒用户
        UIAlertView * PhotoAlareView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"您的相册打不开" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        PhotoAlareView.tag = 0;
        [PhotoAlareView show];
    }
}

#pragma mark UIImagePickerControllerDelegate
//选中一张图片后进入这个方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString * type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片时候
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转为NSData,注意传给图片页面的不能是在沙盒中的路径，因为不管选择哪张图片路径都是一样，所以要把选中的图片传过去
        UIImage * ShowImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //设置image的尺寸
        CGSize imagesize = ShowImage.size;
        imagesize.height = 150;
        imagesize.width = 150;
        //对图片大小进行压缩
        ShowImage = [self imageWithImage:ShowImage scaledToSize:imagesize];
        
        NSData * data;
        if (UIImagePNGRepresentation(ShowImage)==nil)
        {
            data = UIImageJPEGRepresentation(ShowImage,1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(ShowImage);
        }
        
        [self.PhotoArray addObject:ShowImage];
        
        [self reloadData];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

//对图片尺寸进行压缩的方法
-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//点击取消按钮执行的方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您选择了取消图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 多选图片
-(void)ManyBtnClick
{
    NSLog(@"选择多张图片");
    
    QBImagePickerController * imagePickerController = [[QBImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.mediaType = QBImagePickerMediaTypeImage;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 6;
    [[self viewController]presentViewController:imagePickerController animated:YES completion:NULL];
}

#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
{
    if (self.PhotoArray.count + assets.count >10)
    {
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"所选总数已超10张" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [av show];
    }
    else
    {
        //在这时处理选好的图片显示问题
        for (int i = 0; i<assets.count; i++)
        {
            [self.PhotoArray addObject:[assets objectAtIndex:i]];
        }
        
        [self reloadData];
        [[self viewController]dismissViewControllerAnimated:YES completion:NULL];
    }

}

//进入多选图片页面选择好所有图片点击done按钮时候调用
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets;
{
}
//
//- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
//{
    //判断选择图片是否超出
//}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Canceled.");
    
    [[self viewController] dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark CollectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.PhotoArray.count == 0)
    {
        return 1;
    }
    else if(self.PhotoArray.count == 10)
    {
        return self.PhotoArray.count;
    }
    else
    {
        return self.PhotoArray.count +1;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.PhotoArray.count == 0)
    {
        //没有选择数量的时候
        AloneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CWAloneCell forIndexPath:indexPath];
        return cell;
    }
    else if(self.PhotoArray.count == 10)
    {
        //数量选满
        MyCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CWCollectionCell forIndexPath:indexPath];
        
        cell.delegate = self;
        
        //判断数据源类型
        if ([[self.PhotoArray objectAtIndex:indexPath.row] isKindOfClass:[UIImage class]])
        {
            cell.ImageView.image = self.PhotoArray[indexPath.row];
        }
        else
        {
            PHAsset * Asset = [self.PhotoArray objectAtIndex:indexPath.row];
            PHImageRequestOptions * options = [[PHImageRequestOptions alloc]init];
            options.deliveryMode = PHImageContentModeAspectFill;
            [[PHImageManager defaultManager]requestImageForAsset:Asset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
             {
                 cell.ImageView.image = result;
             }];
        }
        
        return cell;
    }
    else
    {
        //1<count<10
        if (indexPath.row<self.PhotoArray.count)
        {
            //显示的图片(不算最后一个)
            MyCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CWCollectionCell forIndexPath:indexPath];
            
            cell.delegate = self;
            
            //判断数据源类型
            if ([[self.PhotoArray objectAtIndex:indexPath.row] isKindOfClass:[UIImage class]])
            {
                cell.ImageView.image = self.PhotoArray[indexPath.row];
            }
            else
            {
                PHAsset * Asset = [self.PhotoArray objectAtIndex:indexPath.row];
                PHImageRequestOptions * options = [[PHImageRequestOptions alloc]init];
                options.deliveryMode = PHImageContentModeAspectFill;
                [[PHImageManager defaultManager]requestImageForAsset:Asset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
                 {
                     cell.ImageView.image = result;
                 }];
            }
            return cell;
        }
        else
        {
            //单独处理最后一个
            AloneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CWAloneCell forIndexPath:indexPath];
            return cell;
        }
    }
}

//是否可以被选
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.PhotoArray.count == 0)
    {
        return YES;
    }
    else if(self.PhotoArray.count<10)
    {
        if (indexPath.row<self.PhotoArray.count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return NO;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击事件");
    Sheet = [[UIActionSheet alloc]initWithTitle:nil
                                       delegate:self
                              cancelButtonTitle:@"取消"
                         destructiveButtonTitle:nil
                              otherButtonTitles:@"打开照相机",@"从相册获取", nil];
    [Sheet showInView:self.superview];
}

//Sheet的代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == Sheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    switch (buttonIndex)
    {
        case 0:
            //相机
            [self AloneBtnClick];
            break;
        case 1:
            //相册
            [self ManyBtnClick];
            break;
        default:
            break;
    }
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //top, left, bottom, right;
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//获取View的viewController
- (UIViewController *)viewController
{
    for (UIView * next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

//Cell代理方法
-(void)GetValue:(MyCollectionViewCell *)cell
{
    NSIndexPath * indexPath = [self indexPathForCell:cell];
    [self.PhotoArray removeObjectAtIndex:indexPath.row];
    [self reloadData];
}

@end
