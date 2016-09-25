using MonitoringTourSystem.Infrastructure.EntityFramework;
using MonitoringTourSystem.ViewModel;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MonitoringTourSystem.Controllers
{
    public class HomeController : Controller
    {
        public readonly monitoring_tourEntities1 MonitoringTourSystem = new monitoring_tourEntities1();
        public List<tourguide> ListLocationTourGuide { get; set; }
        public ActionResult Index()
        {
            //ListLocationTourGuide = MonitoringTourSystem.location_tour_guide.ToList();
            var model = new HomeViewModel() {OptionRenderView = 2 };
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

        //static float longFake = 0.001f;
        //static float lagFake = 0.001f;
        //[HttpGet]
        //public JsonResult GetLocationTourGuide()
        //{
        //   // ListLocationTourGuide = MonitoringTourSystem.location_tour_guide.ToList();
        //    for (int i = 0; i < ListLocationTourGuide.Count; i++)
        //    {
        //        if (i % 2 == 0)
        //        {
        //            ListLocationTourGuide[i].latitude = (float.Parse(ListLocationTourGuide[i].latitude) + lagFake).ToString();
        //            ListLocationTourGuide[i].longitude = (float.Parse(ListLocationTourGuide[i].longitude) + lagFake).ToString();
        //        }
        //        else
        //        {
        //            ListLocationTourGuide[i].latitude = (float.Parse(ListLocationTourGuide[i].latitude) - lagFake).ToString();
        //            ListLocationTourGuide[i].longitude = (float.Parse(ListLocationTourGuide[i].longitude) - lagFake).ToString();
        //        }
        //    }
        //    longFake = longFake + 0.001f;
        //    lagFake = lagFake + 0.001f;
        //    var jsonString = JsonConvert.SerializeObject(ListLocationTourGuide);
        //    return Json(jsonString, JsonRequestBehavior.AllowGet);
        //}

        //public JsonResult CreateMarker()
        //{
        //   // ListLocationTourGuide = MonitoringTourSystem.location_tour_guide.ToList();
        //    var jsonString = JsonConvert.SerializeObject(ListLocationTourGuide);
        //    return Json(jsonString, JsonRequestBehavior.AllowGet);
        //}

        //[HttpGet]
        //public JsonResult GetLocationMarkerSelected(int id)
        //{
        //   // var itemResult = MonitoringTourSystem.location_tour_guide.Where(item => item.tour_guide_id == id);
        //    var jsonString = JsonConvert.SerializeObject(itemResult);
        //    return Json(jsonString, JsonRequestBehavior.AllowGet);
        //}


        //public ActionResult SearchTourGuide(string id)
        //{
        //    var listSearchResult = from item in MonitoringTourSystem.location_tour_guide
        //                           where item.tour_guide_id.ToString().Contains(id)
        //                           select item;
        //    var model = new HomeViewModel() { ListLocationTourGuide = listSearchResult.ToList(), OptionRenderView = 0 };
        //    return PartialView("ListTourGuide", model);
        //}

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