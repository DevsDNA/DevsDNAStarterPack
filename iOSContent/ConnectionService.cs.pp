[assembly: Xamarin.Forms.Dependency(typeof($rootnamespace$.CommonServices.ConnectionService))]
namespace $rootnamespace$.CommonServices
{    
    using System.Net;
    using SystemConfiguration;

    /// <summary>
    /// Connection service iOS implementation
    /// </summary>
    public class ConnectionService : IConnectionService
    {
        private static NetworkReachability defaultRoute;

        /// <summary>
        /// Default constructor <see cref="IConnectionService"/>
        /// </summary>
        public ConnectionService()
        {
            defaultRoute = new NetworkReachability(new IPAddress(0));
        }

        /// <summary>
        /// <see cref="IConnectionService"/>
        /// </summary>
        /// <returns>
        /// <see cref="IConnectionService"/>
        /// </returns>
        public bool HasConnection()
        {
            NetworkReachabilityFlags flags;
            defaultRoute.TryGetFlags(out flags);

            return flags.HasFlag(NetworkReachabilityFlags.Reachable);
        }

        /// <summary>
        /// <see cref="IConnectionService"/>
        /// </summary>
        /// <returns>
        /// <see cref="IConnectionService"/>
        /// </returns>
        public bool IsWiFiEnabled()
        {
            bool isWifiEnabled = false;
            NetworkReachabilityFlags flags;
            defaultRoute.TryGetFlags(out flags);

            isWifiEnabled = !flags.HasFlag(NetworkReachabilityFlags.IsWWAN);

            return isWifiEnabled;
        }
    }
}
