using Microsoft.AspNet.SignalR;
using MonitoringTourSystem.RealTimeServer.BaseMappingConnection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Threading.Tasks;
using MonitoringTourSystem.Infrastructures.EntityFramework;
using System.Web.Security;
using MonitoringTourSystem.RealTimeServer.Model;

namespace MonitoringTourSystem.RealTimeServer
{

    public class HubServer : Hub
    {
        private readonly static ConnectionMapping<string> _connections = new ConnectionMapping<string>();
        private readonly static ConnectionMappingGroup _groups = new ConnectionMappingGroup();


        public override Task OnConnected()
        {

            var groupId = GetUserIDManager();
            var groupName = RoomNameDefine.GROUP_NAME_MANAGER + groupId;

            Groups.Add(Context.ConnectionId, groupName);

            _connections.Add(Context.User.Identity.Name, Context.ConnectionId);

            _groups.Add(groupName, Context.ConnectionId);

            UpdateCountUserOnline(groupName);

            return base.OnConnected();
        }


        public override Task OnDisconnected(bool stopCalled)
        {
            string name = Context.User.Identity.Name;
            _connections.Remove(name, Context.ConnectionId);
            _groups.Remove(RoomNameDefine.GROUP_NAME_MANAGER + Context.User.Identity.Name, Context.ConnectionId);

            UpdateCountUserOnline(RoomNameDefine.GROUP_NAME_MANAGER + Context.User.Identity.Name);
            return base.OnDisconnected(stopCalled);
        }


        public override Task OnReconnected()
        {
            string name = Context.User.Identity.Name;
            if (!_connections.GetConnections(name).Contains(Context.ConnectionId))
            {
                _connections.Add(name, Context.ConnectionId);
                _groups.Add(RoomNameDefine.GROUP_NAME_MANAGER + Context.User.Identity.Name, Context.ConnectionId);

                UpdateCountUserOnline(RoomNameDefine.GROUP_NAME_MANAGER + Context.User.Identity.Name);
            }

            return base.OnReconnected();
        }

        // Get user id manger for Group name
        public string GetUserIDManager()
        {
            var userId = Context.QueryString["MANAGER_ID"];

            if(userId == null)
            {
                return Context.User.Identity.Name;
            }
            else
            {
                return userId;
            }
        }

        //Test send message

        public void SendMessageInGroup(string message)
        {
            var userID = GetUserIDManager();

            var groupName = RoomNameDefine.GROUP_NAME_MANAGER + userID;

            Clients.Group(groupName).sendMessager(message);
        }

        public void SendMessageTo(List<string> who, string message)
        {
            for (int i = 0; i < who.Count; i++)
            {
                foreach (var connection in _connections.GetConnections(who[i]))
                {
                    Clients.Client(connection).sendMessager(message);
                }
            }
        }


        // Update Number of user online
        public void UpdateCountUserOnline(string groupName)
        {
            for(int i = 0; i < _groups._groups.Count; i++)
            {
                if(_groups._groups[i].GroupName == groupName)
                {
                    Clients.Group(groupName).updateNumberOfOnline(_groups._groups[i].ConnectionId.Count);
                }
            }
        }

        // send warning

        

        public void UpdateLocation(object location)
        {

            //foreach (var connection in _connections.GetConnections(1.ToString()))
            //{
            //    Clients.Client(connection).sendMessager(message);
            //}


            // update location for manager.

        }

        public void AddMarker(object marker)
        {
            // add marker user when a new user connect
        }

        public void Remove(object marker)
        {
            // remove marker user when a new user disconnect
        }


    }
}