// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGCurrency.h instead.

@import CoreData;
#import "KGManagedObject.h"

extern const struct KGCurrencyAttributes {
	__unsafe_unretained NSString *base;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *rate;
	__unsafe_unretained NSString *title;
} KGCurrencyAttributes;

@interface KGCurrencyID : NSManagedObjectID {}
@end

@interface _KGCurrency : KGManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KGCurrencyID* objectID;

@property (nonatomic, strong) NSNumber* base;

@property (atomic) float baseValue;
- (float)baseValue;
- (void)setBaseValue:(float)value_;

//- (BOOL)validateBase:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* identifier;

@property (atomic) int64_t identifierValue;
- (int64_t)identifierValue;
- (void)setIdentifierValue:(int64_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* rate;

//- (BOOL)validateRate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@end

@interface _KGCurrency (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveBase;
- (void)setPrimitiveBase:(NSNumber*)value;

- (float)primitiveBaseValue;
- (void)setPrimitiveBaseValue:(float)value_;

- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int64_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int64_t)value_;

- (NSString*)primitiveRate;
- (void)setPrimitiveRate:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

@end
