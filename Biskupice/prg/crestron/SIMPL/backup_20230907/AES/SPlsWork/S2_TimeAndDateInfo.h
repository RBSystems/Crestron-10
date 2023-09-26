#ifndef __S2_TIMEANDDATEINFO_H__
#define __S2_TIMEANDDATEINFO_H__




/*
* Constructor and Destructor
*/

/*
* DIGITAL_INPUT
*/
#define __S2_TimeAndDateInfo_UPDATE_TIME_DIG_INPUT 0
#define __S2_TimeAndDateInfo_UPDATE_DATE_DIG_INPUT 1


/*
* ANALOG_INPUT
*/
#define __S2_TimeAndDateInfo_DATEFORMAT_ANALOG_INPUT 0




/*
* DIGITAL_OUTPUT
*/


/*
* ANALOG_OUTPUT
*/
#define __S2_TimeAndDateInfo_DAY_OF_WEEK_ANALOG_OUTPUT 0
#define __S2_TimeAndDateInfo__MONTH_ANALOG_OUTPUT 1
#define __S2_TimeAndDateInfo__DAY_ANALOG_OUTPUT 2
#define __S2_TimeAndDateInfo_MONTHDAYWORD_ANALOG_OUTPUT 3
#define __S2_TimeAndDateInfo__YEAR_ANALOG_OUTPUT 4
#define __S2_TimeAndDateInfo_HOUR_ANALOG_OUTPUT 5
#define __S2_TimeAndDateInfo_MINUTE_ANALOG_OUTPUT 6
#define __S2_TimeAndDateInfo_SECOND_ANALOG_OUTPUT 7

#define __S2_TimeAndDateInfo_DAY_OF_WEEK$_STRING_OUTPUT 8
#define __S2_TimeAndDateInfo_SHORT_DAY_OF_WEEK$_STRING_OUTPUT 9
#define __S2_TimeAndDateInfo_MONTH$_STRING_OUTPUT 10
#define __S2_TimeAndDateInfo_TIME$_STRING_OUTPUT 11
#define __S2_TimeAndDateInfo_DATE$_STRING_OUTPUT 12


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

START_GLOBAL_VAR_STRUCT( S2_TimeAndDateInfo )
{
   void* InstancePtr;
   struct GenericOutputString_s sGenericOutStr;
   unsigned short LastModifiedArrayIndex;

};

START_NVRAM_VAR_STRUCT( S2_TimeAndDateInfo )
{
};



#endif //__S2_TIMEANDDATEINFO_H__

