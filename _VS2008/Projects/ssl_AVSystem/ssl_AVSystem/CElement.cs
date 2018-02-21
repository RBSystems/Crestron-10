using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_AVSystem
{
    public class CElement
    {
        public static ushort SHORT_NAME_LENGTH = 10;
        public static ushort LONG_NAME_LENGTH = 30;
        
        public ushort Id { get; private set; }
        public ushort IsEnabled { get; protected set; }
        public string NameShort { get; protected set; }
        public string NameLong { get; protected set; }

        public CElement()
        {
        }

        public CElement(ushort _id)
        {
            Id = _id;
            IsEnabled = 0;
            InitializeDefaultNames();
        }

        protected virtual void InitializeDefaultNames()
        {
        }

        public void Initialize(CElement _element)
        {
            Id = _element.Id;
            IsEnabled = _element.IsEnabled;
            NameShort = _element.NameShort;
            NameLong = _element.NameLong;
            OnInfoChanged();
        }

        public void Enable()
        {
            IsEnabled = 1;
        }

        public void Disable()
        {
            IsEnabled = 0;
        }

        public void ToggleEnabled()
        {
            if (IsEnabled == 0) IsEnabled = 1;
            else IsEnabled = 0;
        }

        public void SetNameShort(string _nameShort)
        {
            if (_nameShort.Length == 0) return;
            else NameShort = _nameShort;
        }

        public void SetNameLong(string _nameLong)
        {
            if (_nameLong.Length == 0) return;
            else NameLong = _nameLong;
        }

        public virtual void OnInfoChanged()
        {
        }

    }
}