//
//  ZHVerifyTool.h
//
//  Created by Lee on 2016/9/25.
//  Copyright © 2016年 leezhihua All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, VerifyType) {
    VerifyTypeEmail = 0,
    VerifyTypePhone,
    VerifyTypeIDCard,
    VerifyTypeBankNumber,
    VerifyTypeURL,
    VerifyTypeUserName,//2-4位的中文或1-30位英文
    VerifyTypePassword,//6-18位数字和字母组合的密码
};


@interface ZHVerifyTool : NSObject

/**
 校验数据合规性

 @param value 校验的数据
 @param type 类型
 @return 合规性-YES合规，NO-不合格
 */
+ (BOOL)verifyValue:(NSString *)value type:(VerifyType)type;

/**
 校验数据合规性，使用谓词

 @param value 校验的数据
 @param format 谓词
 @return 合规性-YES合规，NO-不合格
 */
+ (BOOL)verifyValue:(NSString *)value format:(NSString *)format;
@end
