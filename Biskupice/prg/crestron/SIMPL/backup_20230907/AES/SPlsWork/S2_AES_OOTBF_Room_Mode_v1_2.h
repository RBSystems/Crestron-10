#ifndef __S2_AES_OOTBF_ROOM_MODE_V1_2_H__
#define __S2_AES_OOTBF_ROOM_MODE_V1_2_H__




/*
* Constructor and Destructor
*/

/*
* DIGITAL_INPUT
*/
#define __S2_AES_OOTBF_Room_Mode_v1_2_KNOBRIGHT_DIG_INPUT 0
#define __S2_AES_OOTBF_Room_Mode_v1_2_KNOBLEFT_DIG_INPUT 1
#define __S2_AES_OOTBF_Room_Mode_v1_2_ENTER_DIG_INPUT 2
#define __S2_AES_OOTBF_Room_Mode_v1_2_MENU_DIG_INPUT 3
#define __S2_AES_OOTBF_Room_Mode_v1_2_MORE_DIG_INPUT 4
#define __S2_AES_OOTBF_Room_Mode_v1_2_ROOMANDMORE_DIG_INPUT 5
#define __S2_AES_OOTBF_Room_Mode_v1_2_ROOMMODE_DIG_INPUT 6
#define __S2_AES_OOTBF_Room_Mode_v1_2_DISPLAY_DIG_INPUT 7
#define __S2_AES_OOTBF_Room_Mode_v1_2_EXITGLOBALVOLUME_DIG_INPUT 8
#define __S2_AES_OOTBF_Room_Mode_v1_2_EXITROOMMODE_DIG_INPUT 9
#define __S2_AES_OOTBF_Room_Mode_v1_2_INTERRUPTACTIVE_DIG_INPUT 10
#define __S2_AES_OOTBF_Room_Mode_v1_2_DONOTDISTURBENABLED_DIG_INPUT 11
#define __S2_AES_OOTBF_Room_Mode_v1_2_SLEEPENABLED_DIG_INPUT 12
#define __S2_AES_OOTBF_Room_Mode_v1_2_SLEEPWARNING_DIG_INPUT 13
#define __S2_AES_OOTBF_Room_Mode_v1_2_PRIORITYMODECONTROLOK_DIG_INPUT 14
#define __S2_AES_OOTBF_Room_Mode_v1_2_PRIORITYMODECONTROLFAILED_DIG_INPUT 15
#define __S2_AES_OOTBF_Room_Mode_v1_2_PRIORITYMODECONTROLREMOVED_DIG_INPUT 16

#define __S2_AES_OOTBF_Room_Mode_v1_2_SOFTKEY_DIG_INPUT 17
#define __S2_AES_OOTBF_Room_Mode_v1_2_SOFTKEY_ARRAY_LENGTH 4
#define __S2_AES_OOTBF_Room_Mode_v1_2_SOURCEDISABLED_DIG_INPUT 21
#define __S2_AES_OOTBF_Room_Mode_v1_2_SOURCEDISABLED_ARRAY_LENGTH 10
#define __S2_AES_OOTBF_Room_Mode_v1_2_ROOMBUTTON_DIG_INPUT 31
#define __S2_AES_OOTBF_Room_Mode_v1_2_ROOMBUTTON_ARRAY_LENGTH 24

/*
* ANALOG_INPUT
*/
#define __S2_AES_OOTBF_Room_Mode_v1_2_SOURCEACTIVE_ANALOG_INPUT 0
#define __S2_AES_OOTBF_Room_Mode_v1_2_MAXROOMS_ANALOG_INPUT 1
#define __S2_AES_OOTBF_Room_Mode_v1_2_ROOMSEED_ANALOG_INPUT 2
#define __S2_AES_OOTBF_Room_Mode_v1_2_CURRENTSLEEPTIME_ANALOG_INPUT 3
#define __S2_AES_OOTBF_Room_Mode_v1_2_NEWSLEEPTIME_ANALOG_INPUT 4
#define __S2_AES_OOTBF_Room_Mode_v1_2_PRIORITYMODE_ANALOG_INPUT 5



#define __S2_AES_OOTBF_Room_Mode_v1_2_SOURCETYPE_ANALOG_INPUT 6
#define __S2_AES_OOTBF_Room_Mode_v1_2_SOURCETYPE_ARRAY_LENGTH 10
#define __S2_AES_OOTBF_Room_Mode_v1_2_ROOMSOURCE_ANALOG_INPUT 16
#define __S2_AES_OOTBF_Room_Mode_v1_2_ROOMSOURCE_ARRAY_LENGTH 24
#define __S2_AES_OOTBF_Room_Mode_v1_2_SOURCEOWNER_ANALOG_INPUT 40
#define __S2_AES_OOTBF_Room_Mode_v1_2_SOURCEOWNER_ARRAY_LENGTH 10
#define __S2_AES_OOTBF_Room_Mode_v1_2_SOURCENAME$_STRING_INPUT 50
#define __S2_AES_OOTBF_Room_Mode_v1_2_SOURCENAME$_ARRAY_NUM_ELEMS 10
#define __S2_AES_OOTBF_Room_Mode_v1_2_SOURCENAME$_ARRAY_NUM_CHARS 24
CREATE_STRING_ARRAY( S2_AES_OOTBF_Room_Mode_v1_2, __SOURCENAME$, __S2_AES_OOTBF_Room_Mode_v1_2_SOURCENAME$_ARRAY_NUM_ELEMS, __S2_AES_OOTBF_Room_Mode_v1_2_SOURCENAME$_ARRAY_NUM_CHARS );
#define __S2_AES_OOTBF_Room_Mode_v1_2_ROOMNAME$_STRING_INPUT 60
#define __S2_AES_OOTBF_Room_Mode_v1_2_ROOMNAME$_ARRAY_NUM_ELEMS 24
#define __S2_AES_OOTBF_Room_Mode_v1_2_ROOMNAME$_ARRAY_NUM_CHARS 24
CREATE_STRING_ARRAY( S2_AES_OOTBF_Room_Mode_v1_2, __ROOMNAME$, __S2_AES_OOTBF_Room_Mode_v1_2_ROOMNAME$_ARRAY_NUM_ELEMS, __S2_AES_OOTBF_Room_Mode_v1_2_ROOMNAME$_ARRAY_NUM_CHARS );
#define __S2_AES_OOTBF_Room_Mode_v1_2_GROUPNAME$_STRING_INPUT 84
#define __S2_AES_OOTBF_Room_Mode_v1_2_GROUPNAME$_ARRAY_NUM_ELEMS 6
#define __S2_AES_OOTBF_Room_Mode_v1_2_GROUPNAME$_ARRAY_NUM_CHARS 24
CREATE_STRING_ARRAY( S2_AES_OOTBF_Room_Mode_v1_2, __GROUPNAME$, __S2_AES_OOTBF_Room_Mode_v1_2_GROUPNAME$_ARRAY_NUM_ELEMS, __S2_AES_OOTBF_Room_Mode_v1_2_GROUPNAME$_ARRAY_NUM_CHARS );

/*
* DIGITAL_OUTPUT
*/
#define __S2_AES_OOTBF_Room_Mode_v1_2_ENTERFB_DIG_OUTPUT 0
#define __S2_AES_OOTBF_Room_Mode_v1_2_CURRENTROOMON_DIG_OUTPUT 1
#define __S2_AES_OOTBF_Room_Mode_v1_2_DISCONNECT_DIG_OUTPUT 2
#define __S2_AES_OOTBF_Room_Mode_v1_2_CONNECT_DIG_OUTPUT 3
#define __S2_AES_OOTBF_Room_Mode_v1_2_CONNECTNEWSOURCE_DIG_OUTPUT 4


/*
* ANALOG_OUTPUT
*/
#define __S2_AES_OOTBF_Room_Mode_v1_2_CURRENTMENU_ANALOG_OUTPUT 0
#define __S2_AES_OOTBF_Room_Mode_v1_2_SOURCEOUT_ANALOG_OUTPUT 1
#define __S2_AES_OOTBF_Room_Mode_v1_2_SOURCETYPEOUT_ANALOG_OUTPUT 2
#define __S2_AES_OOTBF_Room_Mode_v1_2_NOWPLAYINGINDEX_ANALOG_OUTPUT 3
#define __S2_AES_OOTBF_Room_Mode_v1_2_ROOMSELECTEDFB_ANALOG_OUTPUT 4
#define __S2_AES_OOTBF_Room_Mode_v1_2_USERADJUSTINDEX_ANALOG_OUTPUT 5
#define __S2_AES_OOTBF_Room_Mode_v1_2_INSTALLERADJUSTINDEX_ANALOG_OUTPUT 6
#define __S2_AES_OOTBF_Room_Mode_v1_2_OTHERINDEXOUT_ANALOG_OUTPUT 7
#define __S2_AES_OOTBF_Room_Mode_v1_2_NEWSLEEPTIMEOUT_ANALOG_OUTPUT 8
#define __S2_AES_OOTBF_Room_Mode_v1_2_PRIORITYMODESOURCECONTROLREQUESTED_ANALOG_OUTPUT 9
#define __S2_AES_OOTBF_Room_Mode_v1_2_PRIORITYMODESOURCECONTROLOVERRIDE_ANALOG_OUTPUT 10

#define __S2_AES_OOTBF_Room_Mode_v1_2_SOURCENAMEOUT$_STRING_OUTPUT 11

#define __S2_AES_OOTBF_Room_Mode_v1_2_NEWROOMSOURCE_ANALOG_OUTPUT 22
#define __S2_AES_OOTBF_Room_Mode_v1_2_NEWROOMSOURCE_ARRAY_LENGTH 24
#define __S2_AES_OOTBF_Room_Mode_v1_2_SERIALOUT$_STRING_OUTPUT 12
#define __S2_AES_OOTBF_Room_Mode_v1_2_SERIALOUT$_ARRAY_LENGTH 10

/*
* Direct Socket Variables
*/




/*
* INTEGER_PARAMETER
*/
/*
* SIGNED_INTEGER_PARAMETER
*/
/*
* LONG_INTEGER_PARAMETER
*/
/*
* SIGNED_LONG_INTEGER_PARAMETER
*/
/*
* INTEGER_PARAMETER
*/
/*
* SIGNED_INTEGER_PARAMETER
*/
/*
* LONG_INTEGER_PARAMETER
*/
/*
* SIGNED_LONG_INTEGER_PARAMETER
*/
/*
* STRING_PARAMETER
*/


/*
* INTEGER
*/
CREATE_INTARRAY1D( S2_AES_OOTBF_Room_Mode_v1_2, __OTHERINDEX, 4 );;


/*
* LONG_INTEGER
*/


/*
* SIGNED_INTEGER
*/


/*
* SIGNED_LONG_INTEGER
*/


/*
* STRING
*/
#define __S2_AES_OOTBF_Room_Mode_v1_2_OTHERMENU$_ARRAY_NUM_ELEMS 4
#define __S2_AES_OOTBF_Room_Mode_v1_2_OTHERMENU$_ARRAY_NUM_CHARS 8
CREATE_STRING_ARRAY( S2_AES_OOTBF_Room_Mode_v1_2, __OTHERMENU$, __S2_AES_OOTBF_Room_Mode_v1_2_OTHERMENU$_ARRAY_NUM_ELEMS, __S2_AES_OOTBF_Room_Mode_v1_2_OTHERMENU$_ARRAY_NUM_CHARS );

/*
* STRUCTURE
*/

START_GLOBAL_VAR_STRUCT( S2_AES_OOTBF_Room_Mode_v1_2 )
{
   void* InstancePtr;
   struct GenericOutputString_s sGenericOutStr;
   unsigned short LastModifiedArrayIndex;

   DECLARE_IO_ARRAY( __SOFTKEY );
   DECLARE_IO_ARRAY( __SOURCEDISABLED );
   DECLARE_IO_ARRAY( __ROOMBUTTON );
   DECLARE_IO_ARRAY( __SOURCETYPE );
   DECLARE_IO_ARRAY( __ROOMSOURCE );
   DECLARE_IO_ARRAY( __SOURCEOWNER );
   DECLARE_IO_ARRAY( __NEWROOMSOURCE );
   DECLARE_IO_ARRAY( __SERIALOUT$ );
   unsigned short __CURRENTROOM;
   unsigned short __CURRENTSOURCE;
   unsigned short __TEMPSOURCE;
   unsigned short __TOTALOTHERITEMS;
   unsigned short __WAITINGFORSOURCECONTROL;
   unsigned short __CURRENTMESSAGE;
   DECLARE_INTARRAY( S2_AES_OOTBF_Room_Mode_v1_2, __OTHERINDEX );
   DECLARE_STRING_ARRAY( S2_AES_OOTBF_Room_Mode_v1_2, __OTHERMENU$ );
   DECLARE_STRING_ARRAY( S2_AES_OOTBF_Room_Mode_v1_2, __SOURCENAME$ );
   DECLARE_STRING_ARRAY( S2_AES_OOTBF_Room_Mode_v1_2, __ROOMNAME$ );
   DECLARE_STRING_ARRAY( S2_AES_OOTBF_Room_Mode_v1_2, __GROUPNAME$ );
};

START_NVRAM_VAR_STRUCT( S2_AES_OOTBF_Room_Mode_v1_2 )
{
};

DEFINE_WAITEVENT( S2_AES_OOTBF_Room_Mode_v1_2, SOURCECONTROLWAIT );


#endif //__S2_AES_OOTBF_ROOM_MODE_V1_2_H__
