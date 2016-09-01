using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(MonitoringTourSystem.Startup))]
namespace MonitoringTourSystem
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
