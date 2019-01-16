# ZHVerifyTool
校验数据的合法性

# cocoapods support
```
pod 'ZHVerifyTool'
```

## 使用定义好的枚举
```
BOOL = [ZHVerifyTool verifyValue:@"1888888888" type:VerifyTypePhone];
```
## 使用谓词
```
BOOL = [ZHVerifyTool verifyValue:@"hello" format:@"[A-Za-z]"];
```
