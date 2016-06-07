// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGBaseEntity.m instead.

#import "_KGBaseEntity.h"

@implementation KGBaseEntityID
@end

@implementation _KGBaseEntity

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BaseEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BaseEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BaseEntity" inManagedObjectContext:moc_];
}

- (KGBaseEntityID*)objectID {
	return (KGBaseEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic identifier;

@end

@implementation KGBaseEntityAttributes 
+ (NSString *)identifier {
	return @"identifier";
}
@end

