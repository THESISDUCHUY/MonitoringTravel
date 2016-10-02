using MonitoringTourSystem.EntityFramework;
using MonitoringTourSystem.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MonitoringTourSystem.Controllers
{
    public class TourDetailController : Controller
    {
        public readonly monitoring_tourEntities MonitoringTourSystem = new monitoring_tourEntities();

        // GET: TourDetail
        public ActionResult Index()
        {
            var listTour = MonitoringTourSystem.tours.ToList();
            var model = new TourDetailViewModel() { ListTour = listTour };

            return View("Index", model);
        }

        [HttpPost]
        public ActionResult GetDetailTour(int idTour = 1)
        {
            int indexDay = 0;
            int indexStart = 0;
            List<ScheduleDay> ListScheduleDay = new List<ScheduleDay>();
            var listSchedule = MonitoringTourSystem.tour_schedule.ToList();
            for(int i = 0; i < listSchedule.Count; i++)
            {
                var a = (listSchedule[i].time - listSchedule[indexStart].time).TotalHours;
                if ((listSchedule[i].time - listSchedule[indexStart].time).TotalHours >= 24)
                {
                    var tourSchedule = new List<tour_schedule>();
                    for(int j = indexStart; j < i ; j++)
                    {
                        tourSchedule.Add(listSchedule[j]);

                    }
                    ListScheduleDay.Add(new ScheduleDay() { TourSchedule = tourSchedule});
                    indexStart = i;
                    i = i - 1;
                }
            }
            var tourScheduleItem = new List<tour_schedule>();
            for (int j = indexStart; j < listSchedule.Count; j ++)
            {
                tourScheduleItem.Add(listSchedule[j]);        
            }
            ListScheduleDay.Add(new ScheduleDay() { TourSchedule = tourScheduleItem });

            for(int k = 0; k < ListScheduleDay.Count; k ++)
            {
                indexDay = indexDay + 1;
                ListScheduleDay[k].NumberDay = "NGÀY " + indexDay;
            }

            var model = new TourDetailViewModel() { ListTour = null, ListScheduleDay = ListScheduleDay };
            return PartialView("ScheduleTourTimeline", model);
        }     
    }
    public class ScheduleDay
    {
        public string NumberDay { get; set; }
        public List<tour_schedule> TourSchedule { get; set; }
    }
}
