﻿using MonitoringTourSystem.Infrastructure.EntityFramework;
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
        public readonly monitoring_tourEntities MonitoringTourSystem = new monitoring_tourEntities();

        public List<location_tour_guide> ListLocationTourGuide { get; set; }
        public ActionResult Index()
        {
            //GetLocationTourGuide();
            ListLocationTourGuide = MonitoringTourSystem.location_tour_guide.ToList();
            return View("Index", ListLocationTourGuide);
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
        [HttpGet]
        public JsonResult GetLocationTourGuide()
        {
            ListLocationTourGuide = MonitoringTourSystem.location_tour_guide.ToList();
            for (int i = 0; i < ListLocationTourGuide.Count; i++)
            {
                if (i % 2 == 0)
                {
                    ListLocationTourGuide[i].latitude = (float.Parse(ListLocationTourGuide[i].latitude) + lagFake).ToString();
                    ListLocationTourGuide[i].longitude = (float.Parse(ListLocationTourGuide[i].longitude) + lagFake).ToString();
                }
                else
                {
                    ListLocationTourGuide[i].latitude = (float.Parse(ListLocationTourGuide[i].latitude) - lagFake).ToString();
                    ListLocationTourGuide[i].longitude = (float.Parse(ListLocationTourGuide[i].longitude) - lagFake).ToString();
                }
            }
            longFake = longFake + 0.001f;
            lagFake = lagFake + 0.001f;
            var jsonString = JsonConvert.SerializeObject(ListLocationTourGuide);
            return Json(jsonString, JsonRequestBehavior.AllowGet);
        }

        public JsonResult CreateMarker()
        {
            ListLocationTourGuide = MonitoringTourSystem.location_tour_guide.ToList();
            var jsonString = JsonConvert.SerializeObject(ListLocationTourGuide);
            return Json(jsonString, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult GetLocationMarkerSelected(int id)
        {
            var itemResult = MonitoringTourSystem.location_tour_guide.Where(item => item.tour_guide_id == id);
            var jsonString = JsonConvert.SerializeObject(itemResult);
            return Json(jsonString, JsonRequestBehavior.AllowGet);
        }


        public ActionResult SearchTourGuide(string id)
        {
            var listSearchResult = from item in MonitoringTourSystem.location_tour_guide
                                    where item.tour_guide_id.ToString().Contains(id)
                                    select item;
            return PartialView("ListTourGuide", listSearchResult);
        }

    }
}