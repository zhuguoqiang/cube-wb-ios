/*
 *  global_config.h
 *  MicroVoice
 *
 *  Created by DuanWei on 11-11-30.
 *  Copyright 2011 webrtctel.com All rights reserved.
 *
 */

#define ENABLE_AEC false /*回声消除*/
#define ENABLE_NS false /*噪音抑制*/
#define ENABLE_AGC false

#define ENABLE_SRTP false /*RTP 加密*/
#define ENABLE_VOE_FEC true

#define ENABLED_DEBUG 0 /*输出调试信息*/
#define ENABLED_UI_DEBUG 1

#define ENABLE_ICE 0

#define DEFAULT_TURN_USERNAME "700"
#define DEFAULT_TURN_PASSWORD "700"

#define DEFAULT_SIP_SERVER "183.195.128.38"
#define DEFAULT_CALL_CENTER_NUM "3999"

#define DEFAULT_STUN_SERVER "112.124.62.164:19302"
#define DEFAULT_TURN_SERVER "112.124.62.164:19302"

#define IVLog(format, ...)  NSLog((@"%@" format), @"UI | ", ##__VA_ARGS__)

#define KNotificationOutgoingCall           @"OutgoingCall"

//#define WHITEBOARD_SERVER_HOST @"112.124.62.164"
//#define WHITEBOARD_SERVER_PORT 7000

#define WHITEBOARD_SERVER_HOST @"192.168.1.60"
#define WHITEBOARD_SERVER_PORT 7010



