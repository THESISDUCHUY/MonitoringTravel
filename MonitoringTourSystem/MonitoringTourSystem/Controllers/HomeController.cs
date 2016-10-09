
using MonitoringTourSystem.EntityFramework;
using MonitoringTourSystem.Models;
using MonitoringTourSystem.ViewModel;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MonitoringTourSystem.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        public readonly monitoring_tour_v3Entities MonitoringTourSystem = new monitoring_tour_v3Entities();
        public static List<tourguide> ListTourGuide { get; set; }
        public static List<tourguide> ListTourGuideActive { get; set; }
        public static List<ListTourWithTourGuide> ListStoreForSearch { get; set; }
        public static List<tour> ListTour { get; set; }
        public ActionResult Index()
        {
            //int instance Tour guide active
            ListTourGuideActive = new List<tourguide>();

            //Get all list tour guide
            ListTourGuide = MonitoringTourSystem.tourguides.ToList();

            //Get all list tour
            ListTour = MonitoringTourSystem.tours.ToList();

            // Get list tour is activing
            var listTourActive = (from tourGuide in MonitoringTourSystem.tours 
                                         where tourGuide.status == "Opening"
                                         select tourGuide).ToList();

            for (int i = 0; i < listTourActive.Count; i++)
            {
                var tourGuideActive = ListTourGuide.Where(obj => obj.tourguide_id == listTourActive[i].tourguide_id);
                foreach (var item in tourGuideActive)
                {
                    ListTourGuideActive.Add(item);
                }
            }

            var td = (from s in MonitoringTourSystem.tours
                      join r in MonitoringTourSystem.tourguides on s.tourguide_id equals r.tourguide_id
                      where s.status == StatusTour.Running.ToString()
                     select new
                     {
                        TourSelect = s,
                        TourGuideSelect = r,

                     }).ToList();

            var tourWithTourGuide = new List<ListTourWithTourGuide>();

            for (int i = 0; i < td.Count; i++)
            {
                tourWithTourGuide.Add(new ListTourWithTourGuide() { Tour = td[i].TourSelect, TourGuide = td[i].TourGuideSelect });
            }
            ListStoreForSearch = tourWithTourGuide;
            var model = new HomeViewModel() {OptionRenderView = 1, TourWithTourGuide = tourWithTourGuide};
            
            return View("Index", model);
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }
        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";
            return View();
        }

        static float longFake = 0.001f;
        static float lagFake = 0.001f;


        //[HttpGet]
        //public JsonResult GetLocationTourGuide()
        //{
        //    for (int i = 0; i < ListTourGuide.Count; i++)
        //    {
        //        if (i % 2 == 0)
        //        {
        //            ListTourGuide[i].latitude = (float.Parse(ListTourGuide[i].latitude) + lagFake);
        //            ListTourGuide[i].longitude = (float.Parse(ListTourGuide[i].longitude) + lagFake);
        //        }
        //        else
        //        {
        //            ListTourGuide[i].latitude = ListTourGuide[i].latitude) - lagFake;
        //            ListTourGuide[i].longitude = ListTourGuide[i].longitude) - lagFake;
        //        }
        //    }
        //    longFake = longFake + 0.001f;
        //    lagFake = lagFake + 0.001f;
        //    var jsonString = JsonConvert.SerializeObject(ListTourGuideActive);
        //    return Json(jsonString, JsonRequestBehavior.AllowGet);
        //}
        [HttpGet]
        public JsonResult CreateMarker()
        {
            var jsonString = JsonConvert.SerializeObject(ListTourGuideActive);
            return Json(jsonString, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult GetLocationMarkerSelected(int id)
        {
            var itemResult = MonitoringTourSystem.tourguides.Where(item => item.tourguide_id == id);
            var jsonString = JsonConvert.SerializeObject(itemResult);
            return Json(jsonString, JsonRequestBehavior.AllowGet);
        }


        public ActionResult SearchTourGuide(string id)
        {
           
            if (id != null)
            {
                id = id.ToUpper();
                var listSearchResult = (ListStoreForSearch.Where(x => x.Tour.tour_code.Contains(id))).ToList();
                var model = new HomeViewModel() { TourWithTourGuide = listSearchResult };
                return PartialView("ListTourGuide", model);
            }
            else
            {
                var model = new HomeViewModel() { TourWithTourGuide = ListStoreForSearch };
                return PartialView("ListTourGuide", model);
            }
        }

        //public ActionResult RenderHomeOption(int id)
        //{
        //    var model = new HomeViewModel() { ListLocationTourGuide = null, OptionRenderView = id };
        //    if (model.OptionRenderView == 1)
        //    {
        //        return PartialView("Map", model);

        //    }
        //    if (model.OptionRenderView == 2)
        //    {
        //        return PartialView("Message", model);
        //    }
        //    return null;
        //}

    }
}