#ifndef __S2_TEXT_SCROLLER_H__
#define __S2_TEXT_SCROLLER_H__




/*
* Constructor and Destructor
*/

/*
* DIGITAL_INPUT
*/
#define __S2_text_scroller_DISCROLLUP_DIG_INPUT 0
#define __S2_text_scroller_DISCROLLDOWN_DIG_INPUT 1
#define __S2_text_scroller_DIPAGEUP_DIG_INPUT 2
#define __S2_text_scroller_DIPAGEDOWN_DIG_INPUT 3
#define __S2_text_scroller_DITOPOFLIST_DIG_INPUT 4
#define __S2_text_scroller_DIBOTTOMOFLIST_DIG_INPUT 5
#define __S2_text_scroller_DIRESETSELECTED_DIG_INPUT 6
#define __S2_text_scroller_DISELECTHIGHLIGHTEDITEM_DIG_INPUT 7

#define __S2_text_scroller_DISELECTITEMINWINDOW_DIG_INPUT 8
#define __S2_text_scroller_DISELECTITEMINWINDOW_ARRAY_LENGTH 15

/*
* ANALOG_INPUT
*/
#define __S2_text_scroller_AIPAGESIZE_ANALOG_INPUT 0
#define __S2_text_scroller_AISCROLLBAR_ANALOG_INPUT 1



#define __S2_text_scroller_AIITEMDATA_ANALOG_INPUT 2
#define __S2_text_scroller_AIITEMDATA_ARRAY_LENGTH 50
#define __S2_text_scroller_SIITEMTEXT$_STRING_INPUT 52
#define __S2_text_scroller_SIITEMTEXT$_ARRAY_NUM_ELEMS 50
#define __S2_text_scroller_SIITEMTEXT$_ARRAY_NUM_CHARS 50
CREATE_STRING_ARRAY( S2_text_scroller, __SIITEMTEXT$, __S2_text_scroller_SIITEMTEXT$_ARRAY_NUM_ELEMS, __S2_text_scroller_SIITEMTEXT$_ARRAY_NUM_CHARS );
#define __S2_text_scroller_SIITEMIMAGE$_STRING_INPUT 102
#define __S2_text_scroller_SIITEMIMAGE$_ARRAY_NUM_ELEMS 50
#define __S2_text_scroller_SIITEMIMAGE$_ARRAY_NUM_CHARS 160
CREATE_STRING_ARRAY( S2_text_scroller, __SIITEMIMAGE$, __S2_text_scroller_SIITEMIMAGE$_ARRAY_NUM_ELEMS, __S2_text_scroller_SIITEMIMAGE$_ARRAY_NUM_CHARS );

/*
* DIGITAL_OUTPUT
*/

#define __S2_text_scroller_DOACTUALITEMSELECTED_DIG_OUTPUT 0
#define __S2_text_scroller_DOACTUALITEMSELECTED_ARRAY_LENGTH 50
#define __S2_text_scroller_DOHIGHLIGHTBAR_DIG_OUTPUT 50
#define __S2_text_scroller_DOHIGHLIGHTBAR_ARRAY_LENGTH 15
#define __S2_text_scroller_DOLINESELECTED_DIG_OUTPUT 65
#define __S2_text_scroller_DOLINESELECTED_ARRAY_LENGTH 15

/*
* ANALOG_OUTPUT
*/
#define __S2_text_scroller_AOSCROLLBARF_ANALOG_OUTPUT 0
#define __S2_text_scroller_AOSELECTEDITEMDATA_ANALOG_OUTPUT 1


#define __S2_text_scroller_SOITEMTEXTWINDOW$_STRING_OUTPUT 2
#define __S2_text_scroller_SOITEMTEXTWINDOW$_ARRAY_LENGTH 15
#define __S2_text_scroller_SOITEMIMAGEWINDOW$_STRING_OUTPUT 17
#define __S2_text_scroller_SOITEMIMAGEWINDOW$_ARRAY_LENGTH 15

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

START_GLOBAL_VAR_STRUCT( S2_text_scroller )
{
   void* InstancePtr;
   struct GenericOutputString_s sGenericOutStr;
   unsigned short LastModifiedArrayIndex;

   DECLARE_IO_ARRAY( __DISELECTITEMINWINDOW );
   DECLARE_IO_ARRAY( __DOACTUALITEMSELECTED );
   DECLARE_IO_ARRAY( __DOHIGHLIGHTBAR );
   DECLARE_IO_ARRAY( __DOLINESELECTED );
   DECLARE_IO_ARRAY( __AIITEMDATA );
   DECLARE_IO_ARRAY( __SOITEMTEXTWINDOW$ );
   DECLARE_IO_ARRAY( __SOITEMIMAGEWINDOW$ );
   unsigned short __G_INUMBERITEMS;
   unsigned short __G_IACTUALITEMHIGHLIGHTEDNUM;
   unsigned short __G_IBARPOSITIONINWINDOW;
   unsigned short __G_IITEMNUMBERATTOPOFWINDOW;
   unsigned short __G_IPAGESIZE;
   DECLARE_STRING_ARRAY( S2_text_scroller, __SIITEMTEXT$ );
   DECLARE_STRING_ARRAY( S2_text_scroller, __SIITEMIMAGE$ );
};

START_NVRAM_VAR_STRUCT( S2_text_scroller )
{
};



#endif //__S2_TEXT_SCROLLER_H__

