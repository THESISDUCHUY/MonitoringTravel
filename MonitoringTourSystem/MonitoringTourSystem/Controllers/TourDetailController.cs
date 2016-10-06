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
        private static List<tour> listTour = new List<tour>();
        public ActionResult Index()
        {
            listTour = MonitoringTourSystem.tours.ToList();
            var model = new TourDetailViewModel() { ListTour = listTour };
            return View("Index", model);
        }

        [HttpGet]
        public ActionResult GetDetailTour(int id)
        {
            int indexDay = 0;
            int indexStart = 0;
            List<ScheduleDay> ListScheduleDay = new List<ScheduleDay>();
            var listSchedule = (from schedule in MonitoringTourSystem.tour_schedule
                                where schedule.tour_id == id
                                select schedule).ToList();
           
            for (int i = 0; i < listSchedule.Count; i++)
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

            var idTourGuide = listTour[id].tourguide_id;

            var tourGuideName = (from tourGuide in MonitoringTourSystem.tourguides
                                where tourGuide.tourguide_id == idTourGuide
                                 select tourGuide).ToList();
            

            var model = new TourDetailViewModel() { TourItem = listTour[id], ListScheduleDay = ListScheduleDay, TourGuideName = tourGuideName[0].tourguide_name };
            return PartialView("ScheduleTourTimeline", model);
        }

        [HttpGet]
        public ActionResult SearchTourGuide(string id)
        {
            if (id != null)
            {
                var listTourSearch = (from item in MonitoringTourSystem.tours
                                      where item.tour_code.ToString().Contains(id)
                                      select item).ToList();
                var model = new TourDetailViewModel() { ListTour = listTourSearch };
                return PartialView("ListTour", model);
            } 
            else
            {
                var listTourSearch = MonitoringTourSystem.tours.ToList();
                var model = new TourDetailViewModel() { ListTour = listTourSearch };
                return PartialView("ListTour", model);
            }
            
        }

        [HttpPost]

        public ActionResult SearchByDateAndTown(string regionSearch, DateTime dateSearch)
        {
            if(regionSearch != null && dateSearch != null)
            {
                var listTourSearch = (from item in MonitoringTourSystem.tours
                                      where (item.departure_date < dateSearch && item.return_date > dateSearch)
                                      select item).ToList();
                var model = new TourDetailViewModel() { ListTour = listTourSearch };
                return PartialView("ListTour", model);
            }
            else if(dateSearch != null)
            {
                var listTourSearch = (from item in MonitoringTourSystem.tours
                                      where (item.departure_date < dateSearch && item.return_date > dateSearch)
                                      select item).ToList();
                var model = new TourDetailViewModel() { ListTour = listTourSearch };
                return PartialView("ListTour", model);
            }
            return null;

        }

    }
    public class ScheduleDay
    {
        public string NumberDay { get; set; }
        public List<tour_schedule> TourSchedule { get; set; }
    }
}
