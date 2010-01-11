//
//  YouTubeViedoPlayer.h
//
//  Created by itok on 10/01/11.
//  Copyright 2010 itok. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YouTubeViedoPlayer : NSObject 
{
	NSString* videoId;
	NSURLConnection* m_conn;
	NSMutableData* m_data;
}

@property (nonatomic, retain) NSString* videoId;

-(void) playWithVideoId:(NSString*)videoId;

@end
