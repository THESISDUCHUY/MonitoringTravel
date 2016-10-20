using MonitoringTourSystem.EntityFramework;
using MonitoringTourSystem.Models;
using MonitoringTourSystem.ViewModel;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace MonitoringTourSystem.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        public readonly monitoring_tour_v3Entities MonitoringTourSystem = new monitoring_tour_v3Entities();
        public static List<ListTourWithTourGuide> ListManageTour { get; set; }

        public static List<ListTourWithTourGuide> ListTourGuideWarning { get; set; }
        public static List<tourguide> ListTourGuide { get; set; }
        public static List<ListTourWithTourGuide> ListStoreForSearch { get; set; }

        public static  manager managerID { get; set; }

        public static List<tourguide> ListTourTestRealtime = new List<tourguide>();

        public ActionResult Index()
        {


            string username = FormsAuthentication.Decrypt(Request.Cookies[FormsAuthentication.FormsCookieName].Value).Name;

             managerID = MonitoringTourSystem.managers.Where(s => s.email == username).ToList().FirstOrDefault();

            ListTourGuide = MonitoringTourSystem.tourguides.ToList();
            // Join tourguide table and tour table with key is tourguide_id
            var tourManage = (from s in MonitoringTourSystem.tours
                              join r in MonitoringTourSystem.tourguides on s.tourguide_id equals r.tourguide_id
                              where s.status == StatusTour.Running.ToString() && s.manager_id == managerID.manager_id
                              select new
                              {
                                  TourSelect = s,
                                  TourGuideSelect = r,

                              }).ToList();

            var tourWithTourGuide = new List<ListTourWithTourGuide>();

            for (int i = 0; i < tourManage.Count; i++)
            {
                tourWithTourGuide.Add(new ListTourWithTourGuide() { Tour = tourManage[i].TourSelect, TourGuide = tourManage[i].TourGuideSelect });
                ListTourTestRealtime.Add(tourManage[i].TourGuideSelect);
            }
            ListStoreForSearch = tourWithTourGuide;
            ListManageTour = tourWithTourGuide;



            // Get list warning
            var ListWarningWithReceiver = new List<WarningWithReceiver>();

            //Get listwarning is opening
            var listWarning = MonitoringTourSystem.warnings.Where(s => s.status == StatusWarning.Opening.ToString()).ToList();

            // Get list receiver warning
            var listReceiverWarning = MonitoringTourSystem.warning_receiver.Where(s => s.warner_id == managerID.manager_id).ToList();

            for (int i = 0; i < listWarning.Count; i++)
            {
                var listReceiverOfWarning = listReceiverWarning.Where(s => s.warning_id == listWarning[i].warning_id).ToList();
                if(listReceiverOfWarning.Count != 0)
                {
                    ListWarningWithReceiver.Add(new WarningWithReceiver() { Warning = listWarning[i], ListWarningReceiver = listReceiverOfWarning, QuanityRecevied = listReceiverOfWarning.Where(x => x.status == StatusWarning.Received.ToString()).ToList().Count });
                }
            }


            var model = new HomeViewModel() { OptionRenderView = 1, TourWithTourGuide = tourWithTourGuide, ListWarningWithReceiver = ListWarningWithReceiver };
            return View("Index", model);

        }
        public ActionResult Stock()
        {
            return View("Stock");
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


        #region Get location and fake location

        [HttpGet]
        public JsonResult GetLocationTourGuide()
        {

            //ListTourGuide = MonitoringTourSystem.tourguides.Where(s => s).ToList();
            for (int i = 0; i < ListTourTestRealtime.Count; i++)
            {
                if (i % 2 == 0)
                {
                    ListTourTestRealtime[i].latitude = ListTourTestRealtime[i].latitude + lagFake;
                    ListTourTestRealtime[i].longitude = ListTourTestRealtime[i].longitude + lagFake;

                }
                else
                {
                    ListTourTestRealtime[i].latitude = ListTourTestRealtime[i].latitude - lagFake;
                    ListTourTestRealtime[i].longitude = ListTourTestRealtime[i].longitude - lagFake;
                }
            }

            longFake = longFake + 0.001f;
            lagFake = lagFake + 0.001f;

            var jsonString = JsonConvert.SerializeObject(ListTourTestRealtime);
            return Json(jsonString, JsonRequestBehavior.AllowGet);
        }

        #endregion

        #region Create Marker for tour is running

        [HttpGet]
        public JsonResult CreateMarker()
        {
            //Get list tour is active

            var jsonString = JsonConvert.SerializeObject(new
            {
                objectArray = ListManageTour
            });
            return Json(jsonString, JsonRequestBehavior.AllowGet);
        }

        #endregion


        #region Get location of any marker
        [HttpGet]
        public JsonResult GetLocationMarkerSelected(int id)
        {
            var itemResult = MonitoringTourSystem.tourguides.Where(item => item.tourguide_id == id);
            var jsonString = JsonConvert.SerializeObject(itemResult);
            return Json(jsonString, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region Search tour guide
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

        #endregion

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
        #region Caculator distance and warning

        [HttpPost]
        public ActionResult GetListForWarning( Warning obj )
        {
            ListTourGuideWarning = new List<ListTourWithTourGuide>();

            for (int i = 0; i < ListManageTour.Count; i++)
            {
                var a = GetDistanceFromLatLonInKm(obj.Lat, obj.Long, ListManageTour[i].TourGuide.latitude, ListManageTour[i].TourGuide.longitude);
                if (GetDistanceFromLatLonInKm(obj.Lat, obj.Long, ListManageTour[i].TourGuide.latitude, ListManageTour[i].TourGuide.longitude) < obj.Distance)
                {
                    ListTourGuideWarning.Add(ListManageTour[i]);
                }
            }
            var model = new HomeViewModel() { OptionRenderView = 1, TourWithTourGuide = ListTourGuideWarning };
            return View("ListTourGuideWarning", model);
        }


        [HttpPost]
        public ActionResult GetListWarning()
        {
            // Get list warning
            var ListWarningWithReceiver = new List<WarningWithReceiver>();

            //Get listwarning is opening
            var listWarning = MonitoringTourSystem.warnings.Where(s => s.status == StatusWarning.Opening.ToString()).ToList();

            // Get list receiver warning
            var listReceiverWarning = MonitoringTourSystem.warning_receiver.Where(s => s.warner_id == managerID.manager_id).ToList();

            for (int i = 0; i < listWarning.Count; i++)
            {
                var listReceiverOfWarning = listReceiverWarning.Where(s => s.warning_id == listWarning[i].warning_id).ToList();
                if (listReceiverOfWarning.Count != 0)
                {
                    ListWarningWithReceiver.Add(new WarningWithReceiver() { Warning = listWarning[i], ListWarningReceiver = listReceiverOfWarning, QuanityRecevied = listReceiverOfWarning.Where(x => x.status == StatusWarning.Received.ToString()).ToList().Count });
                }
            }

            var model = new HomeViewModel() { OptionRenderView = 1, TourWithTourGuide = null, ListWarningWithReceiver = ListWarningWithReceiver };
            return View("ListWarning", model);
        }

        // Distance beetween two point
        double GetDistanceFromLatLonInKm(double lat1, double lon1, double lat2, double lon2)
        {
            var R = 6371d; // Radius of the earth in km
            var dLat = Deg2Rad(lat2 - lat1);  // deg2rad below
            var dLon = Deg2Rad(lon2 - lon1);
            var a =
              Math.Sin(dLat / 2d) * Math.Sin(dLat / 2d) +
              Math.Cos(Deg2Rad(lat1)) * Math.Cos(Deg2Rad(lat2)) *
              Math.Sin(dLon / 2d) * Math.Sin(dLon / 2d);
            var c = 2d * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1d - a));
            var d = R * c; // Distance in km
            return d;
        }
        double Deg2Rad(double deg)
        {
            return deg * (Math.PI / 180d);
        }
        //send waring 
        public JsonResult SendWarning(Warning obj)
        {
            try
            {
                int warningID;            
                if (obj != null && ListTourGuideWarning.Count != 0)
                {
                    using (var context = new monitoring_tour_v3Entities())
                    {
                        var warningModel = new warning()
                        {
                            warning_name = obj.WarningName,
                            description = obj.DescriptionWarning,
                            latitude = obj.Lat,
                            longitude = obj.Long,
                            status = StatusWarning.Opening.ToString(),
                            type = obj.CategoryWarnig,
                            distance = obj.Distance
                        };
                        var warningData = context.Set<warning>();
                        warningData.Add(warningModel);
                        context.SaveChanges();
                    }

                    warningID = MonitoringTourSystem.warnings.Max(x => x.warning_id);
                    for (int i = 0; i < ListTourGuideWarning.Count; i++)
                    {
                        var warningReceiver = new warning_receiver()
                        {
                            warning_id = warningID,
                            receiver_id = ListTourGuideWarning[i].Tour.tourguide_id,
                            status = StatusWarning.Opening.ToString(),
                            warner_id = managerID.manager_id,
                        };

                        using (var context = new monitoring_tour_v3Entities())
                        {
                            var warningReceviceData = context.Set<warning_receiver>();
                            warningReceviceData.Add(warningReceiver);
                            context.SaveChanges();
                        }
                    }



                    Response.StatusCode = (int)HttpStatusCode.OK;
                    var result = new { Success = true, Message = "Gửi cảnh báo thành công!" };
                    return Json(result, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    Response.StatusCode = (int)HttpStatusCode.OK;
                    var result = new { Success = false, Message = "Danh sách tour nhận cảnh báo rỗng!" };
                    return Json(result, JsonRequestBehavior.AllowGet);
                }
            }
            catch(Exception ex)
            {
                Response.StatusCode = (int)HttpStatusCode.BadGateway;
                var result = new { Success = false, Message = "Send failed" };
                return Json(result, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpGet]
        public JsonResult GetWarningPosition()
        {

            var listWarningReceiver = MonitoringTourSystem.warning_receiver.Where(s => s.warner_id == managerID.manager_id).GroupBy(x => x.warning_id).Select(y => y.FirstOrDefault()).ToList();

            var listWarningAll = MonitoringTourSystem.warnings.ToList();

            var listWarningOfUser = new List<warning>();
            for (int i = 0; i < listWarningReceiver.Count; i++)
            {
                var warningItem = listWarningAll.Where(x => x.warning_id == listWarningReceiver[i].warning_id).FirstOrDefault();
                listWarningOfUser.Add(warningItem);
            }

            //
            var jsonString = JsonConvert.SerializeObject(listWarningOfUser);
            return Json(jsonString, JsonRequestBehavior.AllowGet);
        }

        //[HttpGet]
        //public void GetListWarning()
        //{

        //    var ListWarningWithReceiver = new List<WarningWithReceiver>();
        
        //    //Get listwarning is opening
        //    var listWarning = MonitoringTourSystem.warnings.Where(s => s.status == StatusWarning.Opening.ToString()).ToList();
        //    // Get list receiver warning
        //    var listReceiverWarning = MonitoringTourSystem.warning_receiver.ToList();

        //    for (int i = 0; i < listWarning.Count; i++)
        //    {
        //        var listReceiverOfWarning = listReceiverWarning.Where(s => s.warning_id == listWarning[i].warning_id).ToList();
        //        ListWarningWithReceiver.Add(new WarningWithReceiver() { Warning = listWarning[i], ListWarningReceiver = listReceiverOfWarning });
        //    }

        //}

        [HttpGet]
        public JsonResult GetMarkerWarningSelected(int id)
        {
            var itemResult = MonitoringTourSystem.warnings.Where(item => item.warning_id == id);
            var jsonString = JsonConvert.SerializeObject(itemResult);
            return Json(jsonString, JsonRequestBehavior.AllowGet);
        }
        #endregion
    }
}