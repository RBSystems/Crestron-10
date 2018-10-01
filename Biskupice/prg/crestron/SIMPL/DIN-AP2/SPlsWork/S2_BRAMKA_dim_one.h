#ifndef __S2_BRAMKA_DIM_ONE_H__
#define __S2_BRAMKA_DIM_ONE_H__




/*
* Constructor and Destructor
*/

/*
* DIGITAL_INPUT
*/
#define __S2_BRAMKA_dim_one_TOG_DIG_INPUT 0
#define __S2_BRAMKA_dim_one_RESET_DIG_INPUT 1
#define __S2_BRAMKA_dim_one_UP_DIG_INPUT 2
#define __S2_BRAMKA_dim_one_XXXSTOP_USUNIETO_DIG_INPUT 3
#define __S2_BRAMKA_dim_one_DWN_DIG_INPUT 4


/*
* ANALOG_INPUT
*/
#define __S2_BRAMKA_dim_one_VAL_ANALOG_INPUT 0

#define __S2_BRAMKA_dim_one_STR_IN_STRING_INPUT 1
#define __S2_BRAMKA_dim_one_STR_IN_STRING_MAX_LEN 40
CREATE_STRING_STRUCT( S2_BRAMKA_dim_one, __STR_IN, __S2_BRAMKA_dim_one_STR_IN_STRING_MAX_LEN );



/*
* DIGITAL_OUTPUT
*/
#define __S2_BRAMKA_dim_one_SW_FB_DIG_OUTPUT 0


/*
* ANALOG_OUTPUT
*/
#define __S2_BRAMKA_dim_one_VAL_FB_ANALOG_OUTPUT 0

#define __S2_BRAMKA_dim_one_STR_OUT_STRING_OUTPUT 1


/*
* Direct Socket Variables
*/




/*
* INTEGER_PARAMETER
*/
#define __S2_BRAMKA_dim_one_NUMER_INTEGER_PARAMETER 10
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

START_GLOBAL_VAR_STRUCT( S2_BRAMKA_dim_one )
{
   void* InstancePtr;
   struct GenericOutputString_s sGenericOutStr;
   unsigned short LastModifiedArrayIndex;

   DECLARE_STRING_STRUCT( S2_BRAMKA_dim_one, __STR_IN );
};

START_NVRAM_VAR_STRUCT( S2_BRAMKA_dim_one )
{
};



#endif //__S2_BRAMKA_DIM_ONE_H__

