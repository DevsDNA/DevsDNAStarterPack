[assembly: Xamarin.Forms.Dependency(typeof($rootnamespace$.CommonServices.SettingsService))]
namespace IoTMM.App.iOS.CommonServices
{
    using Foundation;    
    using Newtonsoft.Json;
    using Security;
    using System;
    using System.Threading.Tasks;

    /// <summary>
    /// Settings service iOS implementation.
    /// </summary>
    public class SettingsService : ISettingsService
    {
        /// <summary>
        /// <see cref="ISettingsService"/>
        /// </summary>
        /// <typeparam name="T"><see cref="ISettingsService"/></typeparam>
        /// <param name="key"><see cref="ISettingsService"/></param>
        /// <param name="isSecure"><see cref="ISettingsService"/></param>
        /// <returns><see cref="ISettingsService"/></returns>
        public Task<T> GetSettingAsync<T>(string key, bool isSecure = false)
        {
            TaskCompletionSource<T> tcs = new TaskCompletionSource<T>();

            if (isSecure)
            {
                SecRecord record = GetRecord(key);
                if (record == null)
                    tcs.TrySetResult(default(T));
                else
                    tcs.TrySetResult(JsonConvert.DeserializeObject<T>(record.ValueData.ToString()));
            }
            else
            {
                if (NSUserDefaults.StandardUserDefaults[key] != null)
                {
                    string value = NSUserDefaults.StandardUserDefaults.StringForKey(key);
                    if (!string.IsNullOrWhiteSpace(value))
                        tcs.TrySetResult(JsonConvert.DeserializeObject<T>(value));
                }
            }
            return tcs.Task;
        }

        /// <summary>
        /// <see cref="ISettingsService"/>
        /// </summary>
        /// <typeparam name="T"><see cref="ISettingsService"/></typeparam>
        /// <param name="key"><see cref="ISettingsService"/></param>
        /// <param name="value"><see cref="ISettingsService"/></param>
        /// <param name="isSecure"><see cref="ISettingsService"/></param>
        /// <returns></returns>
        public Task<bool> SetSettingAsync<T>(string key, T value, bool isSecure = false)
        {
            TaskCompletionSource<bool> tcs = new TaskCompletionSource<bool>();

            if (isSecure)
            {
                bool removed = RemoveRecord(key);
                if (removed)
                {
                    string data = JsonConvert.SerializeObject(value);
                    SecRecord record = new SecRecord(SecKind.GenericPassword);
                    record.Account = key;
                    record.ValueData = NSData.FromString(data);
                    record.Accessible = SecAccessible.WhenUnlocked;
                    var status = SecKeyChain.Add(record);
                    tcs.TrySetResult(status == SecStatusCode.Success);
                }
            }
            else
            {
                string jsonToStore = JsonConvert.SerializeObject(value);
                NSUserDefaults.StandardUserDefaults.SetString(jsonToStore, key);
                NSUserDefaults.StandardUserDefaults.Synchronize();
                tcs.TrySetResult(true);
            }
            return tcs.Task;
        }

        private SecRecord GetRecord(string key)
        {
            SecRecord record = new SecRecord(SecKind.GenericPassword);
            record.Account = key;
            SecStatusCode statusResult;
            var finded = SecKeyChain.QueryAsRecord(record, out statusResult);
            if (statusResult == SecStatusCode.Success)
                return finded;
            return null;
        }

        private bool RemoveRecord(string key)
        {
            SecRecord recordToRemove = GetRecord(key);
            if (recordToRemove != null)
            {
                SecRecord record = new SecRecord(SecKind.GenericPassword);
                record.Account = key;
                var status = SecKeyChain.Remove(record);
                if (status == SecStatusCode.Success)
                    return true;
                else
                    return false;
            }

            return true;
        }
    }
}
