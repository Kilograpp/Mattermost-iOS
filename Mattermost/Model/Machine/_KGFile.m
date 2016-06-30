// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGFile.m instead.

#import "_KGFile.h"

@implementation KGFileID
@end

@implementation _KGFile

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"File" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"File";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"File" inManagedObjectContext:moc_];
}

- (KGFileID*)objectID {
	return (KGFileID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"hasPreviewImageValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hasPreviewImage"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sizeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"size"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic backendLink;

@dynamic backendMimeType;

@dynamic extension;

@dynamic hasPreviewImage;

- (BOOL)hasPreviewImageValue {
	NSNumber *result = [self hasPreviewImage];
	return [result boolValue];
}

- (void)setHasPreviewImageValue:(BOOL)value_ {
	[self setHasPreviewImage:@(value_)];
}

- (BOOL)primitiveHasPreviewImageValue {
	NSNumber *result = [self primitiveHasPreviewImage];
	return [result boolValue];
}

- (void)setPrimitiveHasPreviewImageValue:(BOOL)value_ {
	[self setPrimitiveHasPreviewImage:@(value_)];
}

@dynamic localLink;

@dynamic name;

@dynamic size;

- (int32_t)sizeValue {
	NSNumber *result = [self size];
	return [result intValue];
}

- (void)setSizeValue:(int32_t)value_ {
	[self setSize:@(value_)];
}

- (int32_t)primitiveSizeValue {
	NSNumber *result = [self primitiveSize];
	return [result intValue];
}

- (void)setPrimitiveSizeValue:(int32_t)value_ {
	[self setPrimitiveSize:@(value_)];
}

@dynamic post;

@end

@implementation KGFileAttributes 
+ (NSString *)backendLink {
	return @"backendLink";
}
+ (NSString *)backendMimeType {
	return @"backendMimeType";
}
+ (NSString *)extension {
	return @"extension";
}
+ (NSString *)hasPreviewImage {
	return @"hasPreviewImage";
}
+ (NSString *)localLink {
	return @"localLink";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)size {
	return @"size";
}
@end

@implementation KGFileRelationships 
+ (NSString *)post {
	return @"post";
}
@end

