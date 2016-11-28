

#import <Foundation/Foundation.h>

@interface WXHSaveTool : NSObject

/**
 获取数据

 @param defaultName 数据名称
 @return 返回
 */
+(id)objectForKey:(NSString *)defaultName;

/**
 存储数据

 @param value 数据
 @param defaultName 名称
 */
+(void)setObject:(id)value forKey:(NSString *)defaultName;
@end
