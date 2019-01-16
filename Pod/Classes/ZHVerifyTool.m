//
//  ZHVerifyTool.m
//
//  Created by Lee on 2016/9/25.
//  Copyright © 2016年 leezhihua All rights reserved.
//

#import "ZHVerifyTool.h"

@implementation ZHVerifyTool

+ (BOOL)verifyValue:(NSString *)value type:(VerifyType)type {
    if ([self isBlankString:value]) {
        return NO;
    }
    BOOL result = NO;
    switch (type) {
        case VerifyTypeEmail: {
            result = [self isValidEmail:value];
        }
            break;
        case VerifyTypePhone: {
            result = [self isValidPhone:value];
        }
            break;
        case VerifyTypeIDCard: {
            result = [self isValidIDCard:value];
        }
            break;
        case VerifyTypeBankNumber: {
            result = [self isValidBankNumber:value];
        }
            break;
        case VerifyTypeURL: {
            result = [self isValidURL:value];
        }
            break;
        case VerifyTypeUserName: {
            result = [self isValidUserName:value];
        }
            break;
        case VerifyTypePassword: {
            result = [self isValidPassword:value];
        }
            break;
        default:
            break;
    }
    return result;
}

+ (BOOL)verifyValue:(NSString *)value format:(NSString *)format {
    if ([self isBlankString:value]) {
        return NO;
    }
    NSPredicate *dicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", format];
    return [dicate evaluateWithObject:value];
}

+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]]) {
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isValidEmail:(NSString *)eamil {
    NSArray *array = [eamil componentsSeparatedByString:@"."];
    if ([array count] >= 4) {
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:eamil];
}

#pragma mark 需要更新手机号码段
+ (BOOL)isValidPhone:(NSString *)phone {
    /*
     最新手机号段：
     电信:133、149、153、173、177、180、181、189、199
     联通:130、131、132、145、155、156、166、175、176、185、186
     移动:134(0-8)、135、136、137、138、139、147、150、151、152、157、158、159、178、182、183、184、187、188、198
     其他:17([0,3,5-8])-虚拟、14([5,7,9])-上网卡
     */
    //匹配手机号码的正则表达式
    NSString *format = @"^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", format];
    return [predicate evaluateWithObject:phone];
}

//正则匹配用户身份证号15或18位
+ (BOOL)isValidIDCard:(NSString *)idCard {
    NSInteger length = idCard.length;
    //不满足15位和18位，即身份证错误
    if (length !=15 && length !=18) {
        return NO;
    }
    //省份代码
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    //检测省份身份行政区代码
    NSString *valueStart2 = [idCard substringToIndex:2];
    BOOL areaFlag =NO; //标识省份代码是否正确
    if ([areasArray containsObject:valueStart2]) {
        areaFlag = YES;
    } else {
        return NO;
    }

    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    //分为15位、18位身份证进行校验
    switch (length) {
        case 15:
            //获取年份对应的数字
            year = [idCard substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            //使用正则表达式匹配字符串 NSMatchingReportProgress:找到最长的匹配字符串后调用block回调
            numberofMatch = [regularExpression numberOfMatchesInString:idCard
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, idCard.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [idCard substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:idCard
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, idCard.length)];
            
            
            if(numberofMatch >0) {
                //1：校验码的计算方法 身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2。将这17位数字和系数相乘的结果相加。
                
                int S = [idCard substringWithRange:NSMakeRange(0,1)].intValue*7 + [idCard substringWithRange:NSMakeRange(10,1)].intValue *7 + [idCard substringWithRange:NSMakeRange(1,1)].intValue*9 + [idCard substringWithRange:NSMakeRange(11,1)].intValue *9 + [idCard substringWithRange:NSMakeRange(2,1)].intValue*10 + [idCard substringWithRange:NSMakeRange(12,1)].intValue *10 + [idCard substringWithRange:NSMakeRange(3,1)].intValue*5 + [idCard substringWithRange:NSMakeRange(13,1)].intValue *5 + [idCard substringWithRange:NSMakeRange(4,1)].intValue*8 + [idCard substringWithRange:NSMakeRange(14,1)].intValue *8 + [idCard substringWithRange:NSMakeRange(5,1)].intValue*4 + [idCard substringWithRange:NSMakeRange(15,1)].intValue *4 + [idCard substringWithRange:NSMakeRange(6,1)].intValue*2 + [idCard substringWithRange:NSMakeRange(16,1)].intValue *2 + [idCard substringWithRange:NSMakeRange(7,1)].intValue *1 + [idCard substringWithRange:NSMakeRange(8,1)].intValue *6 + [idCard substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                //2：用加出来和除以11，看余数是多少？余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字 
                int Y = S %11; 
                NSString *M =@"F"; 
                NSString *JYM =@"10X98765432"; 
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 3：获取校验位 
                //4：检测ID的校验位 
                if ([M isEqualToString:[idCard substringWithRange:NSMakeRange(17,1)]]) { 
                    return YES; 
                } else {
                    return NO; 
                }
            } else {
                return NO; 
            } 
        default: 
            return NO; 
    } 
}

/** 银行卡号有效性问题Luhn算法
 * 现行 16 位银联卡现行卡号开头 6 位是 622126～622925 之间的，7 到 15 位是银行自定义的，
 * 可能是发卡分行，发卡网点，发卡序号，第 16 位是校验码。
 * 16 位卡号校验位采用 Luhm 校验方法计算：
 * 1，将未带校验位的 15 位卡号从右依次编号 1 到 15，位于奇数位号上的数字乘以 2
 * 2，将奇位乘积的个十位全部相加，再加上所有偶数位上的数字
 * 3，将加法和加上校验位能被 10 整除。
 */
+ (BOOL)isValidBankNumber:(NSString *)bankNumber{
    NSString *lastNum = [[bankNumber substringFromIndex:(bankNumber.length-1)] mutableCopy];//取出最后一位
    NSString *forwardNum = [[bankNumber substringToIndex:(bankNumber.length -1)] mutableCopy];//前15或18位
    NSMutableArray *forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < forwardNum.length; i++) {
        NSString *subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }
    NSMutableArray *forwardDescArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = (int)(forwardArr.count-1); i > -1; i--) {//前15位或者前18位倒序存进数组
        [forwardDescArr addObject:forwardArr[i]];
    }
    
    NSMutableArray *arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 < 9
    NSMutableArray *arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 > 9
    NSMutableArray *arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];//偶数位数组
    
    for (int i = 0; i < forwardDescArr.count; i++) {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i % 2) {//偶数位
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        } else {//奇数位
            if (num * 2 < 9) {
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            } else {
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }
    
    __block NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNumTotal += [obj integerValue];
    }];
    
    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNum2Total += [obj integerValue];
    }];
    
    __block NSInteger sumEvenNumTotal =0 ;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumEvenNumTotal += [obj integerValue];
    }];
    
    NSInteger lastNumber = [lastNum integerValue];
    
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    
    return (luhmTotal % 10 == 0) ? YES : NO;
}

+ (BOOL)isValidURL:(NSString *)url {
    NSString *regex =@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:url];
}

+ (BOOL)isValidUserName:(NSString *)userName {
    NSString *pattern = @"^[\u4e00-\u9fa5]{2,4}$|^[a-zA-Z]{1,30}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
}

+ (BOOL)isValidPassword:(NSString *)password{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

@end
