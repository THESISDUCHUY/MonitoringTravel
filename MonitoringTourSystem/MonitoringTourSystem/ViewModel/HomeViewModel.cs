
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
        public List<tour> ListLocationTourGuide { get; set; }
        public List<ListTourWithTourGuide> TourWithTourGuide { get; set; }
        public int OptionRenderView { get; set; }
    }

    public class ListTourWithTourGuide
    {
        public tour Tour { get; set; }
        public tourguide TourGuide { get; set; }
    }
}