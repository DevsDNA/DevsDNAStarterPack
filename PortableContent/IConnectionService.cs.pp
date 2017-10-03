namespace $rootnamespace$.CommonServices
{
    /// <summary>
    /// Connection service contract definition.
    /// </summary>
    public interface IConnectionService
    {
        /// <summary>
        /// Check internet connectivity in the device.
        /// </summary>
        /// <returns>True if internet present.</returns>
        bool HasConnection();

        /// <summary>
        /// Check Internet connectivity on the device is through wifi.
        /// </summary>
        /// <returns>True if wifi is enabled</returns>
        bool IsWiFiEnabled();
    }
}
