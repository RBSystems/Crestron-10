using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_AVSystem
{
    public enum StateChangeType { Source, Volume, Mute };

    public class StateChangeEventArgs : EventArgs
    {
        public StateChangeType ChangeType { get; set; }
        public StateChangeEventArgs(StateChangeType _changeType)
        {
            ChangeType = _changeType;
        }
    }
    
    public class CDestination : CElement
    {
        protected const string SOURCE_NONE_TEXT = "Brak";
        protected const string VOLUME_UNKNOWN_TEXT = "??? %";

        public ushort DefaultSourceId { get; private set; }

        public CSource DefaultSource
        {
            get
            {
                if (CElementManager.SourceArray == null) return new CSource(0);
                else return CElementManager.SourceArray[DefaultSourceId];
            }
        }

        public ushort DefaultVolume { get; private set; }

        public ushort IsSourceStartupDefault { get; private set; }

        public ushort IsVolumeStartupDefault { get; private set; }

        public CDestination()
        {
        }

        public CDestination(ushort _id, ushort _defaultSourceId)
            : base(_id)
        {
            IsSourceStartupDefault = 1;
            IsVolumeStartupDefault = 0;
            DefaultSourceId = _defaultSourceId;
            DefaultVolume = 50;
        }

        public void Initialize(CDestination _destination)
        {
            base.Initialize(_destination);
            IsSourceStartupDefault = _destination.IsSourceStartupDefault;
            IsVolumeStartupDefault = _destination.IsVolumeStartupDefault;
            DefaultSourceId = _destination.DefaultSourceId;
            DefaultVolume = _destination.DefaultVolume;
        }

        public void SetDefaultSourceId(ushort _defaultSourceId)
        {
            if (_defaultSourceId > 0 && _defaultSourceId <= CSource.COUNT) DefaultSourceId = _defaultSourceId;
        }

        public void ToggleSourceStartup()
        {
            if (IsSourceStartupDefault == 1) IsSourceStartupDefault = 0;
            else IsSourceStartupDefault = 1;
        }

        public void ToggleVolumeStartup()
        {
            if (IsVolumeStartupDefault == 1) IsVolumeStartupDefault = 0;
            else IsVolumeStartupDefault = 1;
        }

        public void IncreaseDefaultVolume()
        {
            DefaultVolume += CDevice.VOLUME_SHIFT;
            if (DefaultVolume > CDevice.MAX_VOLUME) DefaultVolume = CDevice.MAX_VOLUME;
        }

        public void DecreaseDefaultVolume()
        {
            if (DefaultVolume <= CDevice.MIN_VOLUME) return;

            DefaultVolume -= CDevice.VOLUME_SHIFT;
        }

        public virtual string GetCurrentSourceTextShort()
        {
            return "";
        }

        public virtual string GetCurrentSourceTextLong()
        {
            return "";
        }

        public virtual string GetCurrentVolumeText()
        {
            return "";
        }

        public virtual void SetSource(ushort _sourceId)
        {
        }

        public virtual void SetDefaultSource()
        {
        }

        public virtual void PowerOn()
        {
        }

        public virtual void PowerOff()
        {
        }

        public virtual void TogglePower()
        {
        }

        public virtual void SetVolume(ushort _volume)
        {
        }

        public virtual void SetDefaultVolume()
        {
        }

        public virtual void IncreaseVolume()
        {
        }

        public virtual void DecreaseVolume()
        {
        }

        public virtual void SetMute(ushort _mute)
        {
        }

        public virtual void ToggleMute()
        {
        }

    }
}