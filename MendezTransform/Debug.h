//
//  Debug.h
//  MendezTransform
//
//  Created by Andreas Müller on 26.03.09.
//  Copyright 2009 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>

extern BOOL	debug;

#ifndef NDEBUG
#define NDEBUG 0
#endif

extern void	NSDebugInternal(const char *file, int line, NSString *format, ...);

#if NDEBUG
#define	NSDebug(format, ...)
#define NSDebug1(string)
#else /* NDEBUG */
#define	NSDebug(format, args...)	NSDebugInternal(__FILE__, __LINE__, format, args)
#define	NSDebug1(string)				NSDebugInternal(__FILE__, __LINE__, @"%@", string)
#endif /* NDEBUG */
