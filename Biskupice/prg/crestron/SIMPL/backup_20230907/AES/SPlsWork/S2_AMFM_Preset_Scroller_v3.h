#ifndef __S2_AMFM_PRESET_SCROLLER_V3_H__
#define __S2_AMFM_PRESET_SCROLLER_V3_H__




/*
* Constructor and Destructor
*/

/*
* DIGITAL_INPUT
*/
#define __S2_AMFM_Preset_Scroller_v3_SCROLLPRESETS_DIG_INPUT 0
#define __S2_AMFM_Preset_Scroller_v3_SCROLLUP_DIG_INPUT 1
#define __S2_AMFM_Preset_Scroller_v3_SCROLLDOWN_DIG_INPUT 2
#define __S2_AMFM_Preset_Scroller_v3_SCROLLSELECT_DIG_INPUT 3
#define __S2_AMFM_Preset_Scroller_v3_SCROLLSAVEPRESET_DIG_INPUT 4
#define __S2_AMFM_Preset_Scroller_v3_SCROLLCLEARPRESET_DIG_INPUT 5
#define __S2_AMFM_Preset_Scroller_v3_AMACTIVE_DIG_INPUT 6


/*
* ANALOG_INPUT
*/
#define __S2_AMFM_Preset_Scroller_v3_SCROLLPAGESIZE_ANALOG_INPUT 0
#define __S2_AMFM_Preset_Scroller_v3_AMPRESETMODE_ANALOG_INPUT 1
#define __S2_AMFM_Preset_Scroller_v3_FMPRESETMODE_ANALOG_INPUT 2



#define __S2_AMFM_Preset_Scroller_v3_AMPRESETVALUE_ANALOG_INPUT 3
#define __S2_AMFM_Preset_Scroller_v3_AMPRESETVALUE_ARRAY_LENGTH 20
#define __S2_AMFM_Preset_Scroller_v3_FMPRESETVALUE_ANALOG_INPUT 23
#define __S2_AMFM_Preset_Scroller_v3_FMPRESETVALUE_ARRAY_LENGTH 20

/*
* DIGITAL_OUTPUT
*/
#define __S2_AMFM_Preset_Scroller_v3_CHANNELSELECTED_DIG_OUTPUT 0

#define __S2_AMFM_Preset_Scroller_v3_SCROLLHIGHLIGHTFB_DIG_OUTPUT 1
#define __S2_AMFM_Preset_Scroller_v3_SCROLLHIGHLIGHTFB_ARRAY_LENGTH 10
#define __S2_AMFM_Preset_Scroller_v3_AMPRESETSELECT_DIG_OUTPUT 11
#define __S2_AMFM_Preset_Scroller_v3_AMPRESETSELECT_ARRAY_LENGTH 20
#define __S2_AMFM_Preset_Scroller_v3_FMPRESETSELECT_DIG_OUTPUT 31
#define __S2_AMFM_Preset_Scroller_v3_FMPRESETSELECT_ARRAY_LENGTH 20

/*
* ANALOG_OUTPUT
*/
#define __S2_AMFM_Preset_Scroller_v3_AMPRESETMODEOUT_ANALOG_OUTPUT 0
#define __S2_AMFM_Preset_Scroller_v3_FMPRESETMODEOUT_ANALOG_OUTPUT 1

#define __S2_AMFM_Preset_Scroller_v3_SCROLLHEADER$_STRING_OUTPUT 2

#define __S2_AMFM_Preset_Scroller_v3_SCROLLLIST$_STRING_OUTPUT 3
#define __S2_AMFM_Preset_Scroller_v3_SCROLLLIST$_ARRAY_LENGTH 10

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

/*
* STRUCTURE
*/

START_GLOBAL_VAR_STRUCT( S2_AMFM_Preset_Scroller_v3 )
{
   void* InstancePtr;
   struct GenericOutputString_s sGenericOutStr;
   unsigned short LastModifiedArrayIndex;

   DECLARE_IO_ARRAY( __SCROLLHIGHLIGHTFB );
   DECLARE_IO_ARRAY( __AMPRESETSELECT );
   DECLARE_IO_ARRAY( __FMPRESETSELECT );
   DECLARE_IO_ARRAY( __AMPRESETVALUE );
   DECLARE_IO_ARRAY( __FMPRESETVALUE );
   DECLARE_IO_ARRAY( __SCROLLLIST$ );
   unsigned short __SCROLLINDEX;
   unsigned short __SCROLLHIGHLIGHT;
   unsigned short __SCROLLMAX;
   unsigned short __PRESETTOSAVE;
   unsigned short __OLDSCROLLINDEX;
   unsigned short __OLDSCROLLHIGHLIGHT;
};

START_NVRAM_VAR_STRUCT( S2_AMFM_Preset_Scroller_v3 )
{
};



#endif //__S2_AMFM_PRESET_SCROLLER_V3_H__

