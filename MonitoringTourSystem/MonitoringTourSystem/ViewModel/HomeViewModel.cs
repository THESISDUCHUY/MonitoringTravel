using MonitoringTourSystem.Infrastructure.EntityFramework;
using MonitoringTourSystem.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MonitoringTourSystem.ViewModel
{
    public class HomeViewModel
    {
        public List<tourguide> ListLocationTourGuide { get; set; }
        public int OptionRenderView { get; set; }
    }
}