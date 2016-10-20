
using MonitoringTourSystem.EntityFramework;
using MonitoringTourSystem.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MonitoringTourSystem.ViewModel
{
    public class HomeViewModel
    {
        public List<ListTourWithTourGuide> TourWithTourGuide { get; set; }
        public List<WarningWithReceiver> ListWarningWithReceiver { get; set; }
        public int OptionRenderView { get; set; }
    }

    public class ListTourWithTourGuide
    {
        public tour Tour { get; set; }
        public tourguide TourGuide { get; set; }
        public List<warning_receiver> ListWarning { get; set; }
    }


    public class WarningWithReceiver
    {
        public warning Warning { get; set; }
        public List<warning_receiver> ListWarningReceiver { get; set; }

        public int QuanityRecevied { get; set; }
    }
}