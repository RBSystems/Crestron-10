using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_AVSystem
{
    public class CSource : CElement
    {        
        public static ushort COUNT = 32;

        public static event EventHandler SourceInfoChanged;

        public ushort AudioId { get; private set; }

        public ushort VideoId { get; private set; }

        public CSource()
        {
        }

        public CSource(ushort _id)
            : base(_id)
        {
            AudioId = 0;
            VideoId = 0;
        }

        public CSource(ushort _id, ushort _audioId, ushort _videoId)
            : base(_id)
        {
            AudioId = _audioId;
            VideoId = _videoId;
        }

        protected override void InitializeDefaultNames()
        {
            if (Id == 0)
            {
                NameShort = "BRAK";
                NameLong = "BRAK";
                Enable();
            }
            else
            {
                NameShort = "ZR-" + Id;
                NameLong = "Zrodlo - " + Id;
            }
        }

        public void Initialize(CSource _source)
        {
            base.Initialize(_source);
            AudioId = _source.AudioId;
            VideoId = _source.VideoId;
        }

        //  Czy dodać do tej funkcji zachowania pożądana w przypadku zmiany informacji o źródle?
        public override void OnInfoChanged()
        {
            if (CSource.SourceInfoChanged != null) SourceInfoChanged(this, EventArgs.Empty);
        }
    }
}