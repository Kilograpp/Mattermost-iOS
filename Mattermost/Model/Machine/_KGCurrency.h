// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGCurrency.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "KGManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface KGCurrencyID : NSManagedObjectID {}
@end

@interface _KGCurrency : KGManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KGCurrencyID *objectID;

@property (nonatomic, strong, nullable) NSString* base;

@property (nonatomic, strong, nullable) NSNumber* identifier;

@property (atomic) int64_t identifierValue;
- (int64_t)identifierValue;
- (void)setIdentifierValue:(int64_t)value_;

@property (nonatomic, strong, nullable) NSNumber* rate;

@property (atomic) float rateValue;
- (float)rateValue;
- (void)setRateValue:(float)value_;

@property (nonatomic, strong, nullable) NSString* title;

@end

@interface _KGCurrency (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveBase;
- (void)setPrimitiveBase:(NSString*)value;

- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int64_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int64_t)value_;

- (NSNumber*)primitiveRate;
- (void)setPrimitiveRate:(NSNumber*)value;

- (float)primitiveRateValue;
- (void)setPrimitiveRateValue:(float)value_;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

@end

@interface KGCurrencyAttributes: NSObject 
+ (NSString *)base;
+ (NSString *)identifier;
+ (NSString *)rate;
+ (NSString *)title;
@end

NS_ASSUME_NONNULL_END
