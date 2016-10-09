using MonitoringTourSystem.EntityFramework;
using MonitoringTourSystem.Models;
using MonitoringTourSystem.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace MonitoringTourSystem.Controllers
{
    public class TourDetailController : Controller
    {
        public readonly monitoring_tour_v3Entities MonitoringTourSystem = new monitoring_tour_v3Entities();
        public bool IsStartTourActive;
        public static TourDetailViewModel ModelPass;
        // GET: TourDetail
        private static List<tour> listTour = new List<tour>();



        public ActionResult Index()
        {
            listTour = MonitoringTourSystem.tours.ToList();

            var listTourVietNam = listTour.Where(x => x.is_foreign_tour == 0).ToList();
            var listTourForeign = listTour.Where(x => x.is_foreign_tour == 1).ToList();
            var model = new TourDetailViewModel() { ListTour = listTour, ListTourVietNam = listTourVietNam, ListTourForeign = listTourForeign };
            return View("Index", model);
        }

        [HttpGet]
        public ActionResult GetDetailTour(int id)
        {
           
            if(!IsStartTourActive)
            {
                // Nothing
            }
            else
            {
                listTour = MonitoringTourSystem.tours.ToList();
            }
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

            //Get ID Tour Guide of tour
            var idTourGuide = listTour.Where(x => x.tour_id == id).First().tourguide_id;

            var tourGuideName = (from tourGuide in MonitoringTourSystem.tourguides
                                where tourGuide.tourguide_id == idTourGuide
                                 select tourGuide).ToList();
            var touItem = listTour.Where(x => x.tour_id == id).First();

            var model = new TourDetailViewModel() { TourItem = touItem, ListScheduleDay = ListScheduleDay, TourGuideName = tourGuideName[0].tourguide_name };
            ModelPass = model;
            return PartialView("ScheduleTourTimeline", model);
        }

        [HttpGet]
        public ActionResult SearchTourVietNam(string id)
        {
            if (id != null)
            {
                var listTourSearch = (from item in listTour
                                      where item.tour_code.ToString().Contains(id) && item.is_foreign_tour == 0
                                      select item).ToList();
                var model = new TourDetailViewModel() { ListTourVietNam = listTourSearch };
                return PartialView("ListTourVietNam", model);
            } 
            else
            {
                var listTourSearch = listTour.Where(x => x.is_foreign_tour == 0).ToList();
                var model = new TourDetailViewModel() { ListTourVietNam = listTourSearch };
                return PartialView("ListTourVietNam", model);
            }
        }

        [HttpGet]
        public ActionResult SearchTourForeign(string id)
        {
            if (id != null)
            {
                var listTourSearch = (from item in listTour
                                      where item.tour_code.ToString().Contains(id) && item.is_foreign_tour == 1
                                      select item).ToList();
                var model = new TourDetailViewModel() { ListTourForeign = listTourSearch };
                return PartialView("ListTourForeign", model);
            }
            else
            {
                var listTourSearch = listTour.Where(x => x.is_foreign_tour == 1).ToList();
                var model = new TourDetailViewModel() { ListTourForeign = listTourSearch };
                return PartialView("ListTourForeign", model);
            }

        }

        [HttpPost]
        public ActionResult SearchByDateAndTown(string regionSearch, DateTime dateSearch)
        {
            if(regionSearch != null && dateSearch != null && regionSearch != "Chọn miền")
            {
                var listTourSearch = (from item in listTour
                                      where (item.departure_date < dateSearch && item.return_date > dateSearch) && item.is_foreign_tour == 0
                                      select item).ToList();
                var model = new TourDetailViewModel() { ListTourVietNam = listTourSearch };
                return PartialView("ListTourVietNam", model);
            }
            else if(dateSearch != null)
            {
                var listTourSearch = (from item in listTour
                                      where (item.departure_date < dateSearch && item.return_date > dateSearch)
                                      select item).ToList();
                var model = new TourDetailViewModel() { ListTourVietNam = listTourSearch };
                return PartialView("ListTourVietNam", model);
            }
            return null;
        }

        [HttpGet]
        public ActionResult ActiveTour(string id)
        {
            var idInt = Convert.ToInt32(id);
            using (var context = new monitoring_tour_v3Entities())
            {
                var tour = (from item in context.tours
                            where item.tour_id == idInt
                            select item).First();
                tour.status = StatusTour.Running.ToString();
                context.SaveChanges();
                
            }
            IsStartTourActive = true;
            return GetDetailTour(idInt);
        }

        [HttpGet]
        public ActionResult DeleteTour(string id)
        {
            try
            {
                var idInt = Convert.ToInt32(id);
                using (var context = new monitoring_tour_v3Entities())
                {
                    var tour = (from item in context.tours
                                where item.tour_id == idInt
                                select item).First();
                    context.tours.Remove(tour);
                    context.SaveChanges();

                    var listSchedule = (from item in context.tour_schedule
                                        where item.tour_id == idInt
                                        select item).ToList();

                    foreach(var itemSchedule in listSchedule)
                    {
                        context.tour_schedule.Remove(itemSchedule);
                        context.SaveChanges();
                    }

                    listTour.Remove(tour);
                }

                var model = new TourDetailViewModel() { ListTour = listTour};
                return PartialView("Index", model);
            }
            catch(Exception ex)
            {
                Response.StatusCode = (int)HttpStatusCode.BadRequest;
                return null;
            }
        }

        public ActionResult EditTour(string id)
        {
            TempData["TouDetail"] = ModelPass;
            return RedirectToAction(id, "EditTour/EditTour");
        }
    }
    public class ScheduleDay
    {
        public string NumberDay { get; set; }
        public List<tour_schedule> TourSchedule { get; set; }
        
        public string NameProvince { get; set; }


    }
}
