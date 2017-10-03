[assembly: Xamarin.Forms.Dependency(typeof($rootnamespaces$.CommonServices.ConnectionService))]
namespace $rootnamespaces$.CommonServices
{
    using Android.App;
    using Android.Content;
    using Android.Net;    

    /// <summary>
    /// Connection service android implementation
    /// </summary>
    public class ConnectionService : IConnectionService
    {
        /// <summary>
        /// Default Constructor
        /// </summary>
        public ConnectionService() { }

        /// <summary>
        /// <see cref="IConnectionService"/>
        /// </summary>
        /// <returns>
        /// <see cref="IConnectionService"/>
        /// </returns>
        public bool HasConnection()
        {
            var connectivityManager = (ConnectivityManager)Application.Context.GetSystemService(Context.ConnectivityService);
            var activeConnection = connectivityManager.ActiveNetworkInfo;
            return activeConnection != null && 
                   activeConnection.IsConnected;
        }


        /// <summary>
        /// <see cref="IConnectionService"/>
        /// </summary>
        /// <returns>
        /// <see cref="IConnectionService"/>
        /// </returns>
        public bool IsWiFiEnabled()
        {
            var connectivityManager = (ConnectivityManager)Application.Context.GetSystemService(Context.ConnectivityService);
            var activeConnection = connectivityManager.ActiveNetworkInfo;
            return activeConnection != null &&
                   activeConnection.IsConnected && 
                   activeConnection.Type == ConnectivityType.Wifi;
        }
    }
}

