using Microsoft.AspNet.SignalR;
using Owin;

namespace MonitoringTourSystem
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.MapSignalR();
        }

    }
}