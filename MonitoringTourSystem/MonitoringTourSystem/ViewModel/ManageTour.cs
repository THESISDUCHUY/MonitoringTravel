using MonitoringTourSystem.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MonitoringTourSystem.ViewModel
{
    public class ManageTour
    {
        public tour TourInfo { get; set; }
        public tourguide TourGuideInfo { get; set; }
    }
}