namespace $rootnamespace$.CommonServices
{
    using System.Threading.Tasks;

    /// <summary>
    /// Settings service contract definition
    /// </summary>
    public interface ISettingsService
    {
        /// <summary>
        /// Store object on settings
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key">key to identify data.</param>
        /// <param name="value">The value.</param>
        /// <param name="isSecure">Secure or not data.</param>
        /// <returns>
        /// true if value saved, false if failed.
        /// </returns>
        Task<bool> SetSettingAsync<T>(string key, T value, bool isSecure = false);

        /// <summary>
        /// Read data from store.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key">Key to identify data.</param>
        /// <param name="isSecure">Secure or not data.</param>
        /// <returns>
        /// object from store.
        /// </returns>
        Task<T> GetSettingAsync<T>(string key, bool isSecure = false);
    }
}
