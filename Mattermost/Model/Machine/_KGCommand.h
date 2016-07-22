// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGCommand.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "KGManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface KGCommandID : NSManagedObjectID {}
@end

@interface _KGCommand : KGManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KGCommandID *objectID;

@property (nonatomic, strong, nullable) NSString* hint;

@property (nonatomic, strong, nullable) NSString* message;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSString* trigger;

@end

@interface _KGCommand (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveHint;
- (void)setPrimitiveHint:(NSString*)value;

- (NSString*)primitiveMessage;
- (void)setPrimitiveMessage:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveTrigger;
- (void)setPrimitiveTrigger:(NSString*)value;

@end

@interface KGCommandAttributes: NSObject 
+ (NSString *)hint;
+ (NSString *)message;
+ (NSString *)name;
+ (NSString *)trigger;
@end

NS_ASSUME_NONNULL_END
