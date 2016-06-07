// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGBaseEntity.h instead.

@import CoreData;
#import "KGManagedObject.h"

extern const struct KGBaseEntityAttributes {
	__unsafe_unretained NSString *identifier;
} KGBaseEntityAttributes;

@interface KGBaseEntityID : NSManagedObjectID {}
@end

@interface _KGBaseEntity : KGManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KGBaseEntityID* objectID;

@property (nonatomic, strong) NSString* identifier;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@end

@interface _KGBaseEntity (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;

@end
