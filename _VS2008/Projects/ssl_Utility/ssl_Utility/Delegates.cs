using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{
    public delegate void ActionEmptyDelegate();
    public delegate void ActionStringDelegate(SimplSharpString _string1);
    public delegate void ActionUshortDelegate(ushort _ushort1);
    public delegate void ActionUshortUshortDelegate(ushort _ushort1, ushort _ushort2);
    public delegate void ActionUshortUshortUshortDelegate(ushort _ushort1, ushort _ushort2, ushort _ushort3);    
    public delegate void ActionUshortUshortStringDelegate(ushort _ushort1, ushort _ushort2, SimplSharpString _string1);

    public class Dummy
    {
    }
}