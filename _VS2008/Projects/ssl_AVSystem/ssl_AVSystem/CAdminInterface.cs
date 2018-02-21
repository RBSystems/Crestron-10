using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_AVSystem
{
    public enum InterfaceMode { Source, Zone, Group }
    
    public class CAdminInterface
    {
        InterfaceMode selectedMode = InterfaceMode.Source;
        
        public InterfaceMode SelectedMode
        { 
            get { return selectedMode; }
            set
            {
                selectedMode = value;

                switch (selectedMode)
                {
                    case InterfaceMode.Source:
                        {
                            SetSelectedSource(1);
                            SelectedElement = SelectedSource;
                            break;
                        }
                    case InterfaceMode.Zone:
                        {
                            SetSelectedZone(1);
                            SelectedElement = SelectedZone;
                            SelectedDestination = SelectedZone;
                            break;
                        }
                    case InterfaceMode.Group:
                        {
                            SetSelectedGroup(1);
                            SelectedElement = SelectedGroup;
                            SelectedDestination = SelectedGroup;
                            break;
                        }
                }
            }
        }

        public CElement SelectedElement { get; private set; }
        public CSource SelectedSource { get; private set; }
        public CDestination SelectedDestination { get; private set; }
        public CZone SelectedZone { get; private set; }
        public CGroup SelectedGroup { get; private set; }

        public string SaveMessage { get; private set; }

        public CAdminInterface()
        {   
            SelectedSource = new CSource();
            SelectedZone = new CZone();
            SelectedGroup = new CGroup();

            SelectedElement = SelectedSource;
            SelectedDestination = SelectedZone;
        }

        public void Initialize()
        {
            SetSelectedSource(1);
            SetSelectedZone(1);
            SetSelectedGroup(1);
        }

        public void SetSelectedSource(ushort _sourceId)
        {
            if (CElementManager.IsInitialized == 0 || _sourceId > CSource.COUNT) return;

            SelectedSource.Initialize(CElementManager.SourceArray[_sourceId]);
        }

        public void SetSelectedZone(ushort _zoneId)
        {
            if (CElementManager.IsInitialized == 0 || _zoneId > CZone.COUNT) return;

            SelectedZone.Initialize(CElementManager.ZoneArray[_zoneId]);
        }

        public void SetSelectedGroup(ushort _groupId)
        {
            if (CElementManager.IsInitialized == 0 || _groupId > CGroup.COUNT) return;

            SelectedGroup.Initialize(CElementManager.GroupArray[_groupId]);
        }

        public void SaveSelectedElement()
        {
            if (CElementManager.IsInitialized == 0) return;

            switch (selectedMode)
            {
                case InterfaceMode.Source:
                    {
                        CElementManager.SaveElement(SelectedSource);
                        CElementManager.SourceArray[SelectedSource.Id].Initialize(SelectedSource);
                        break;
                    }
                case InterfaceMode.Zone:
                    {
                        CElementManager.SaveElement(SelectedZone);
                        CElementManager.ZoneArray[SelectedZone.Id].Initialize(SelectedZone);
                        break;
                    }
                case InterfaceMode.Group:
                    {
                        if (!SelectedGroup.Schedule.AreTimesCorrect())
                        {
                            SaveMessage = "Niepowodzenie zapisu.\x0D Nieprawidlowe czasy harmonogramu.\x0D Czas zakonczenia musi byc pozniejszy niz czas rozpoczecia.";
                            return;
                        }
                        CElementManager.SaveElement(SelectedGroup);
                        CElementManager.GroupArray[SelectedGroup.Id].Initialize(SelectedGroup);
                        break;
                    }
            }

            SaveMessage = "Zapis zakonczony sukcesem.";
        }

    }

}