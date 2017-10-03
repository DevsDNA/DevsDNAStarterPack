[assembly: Xamarin.Forms.Dependency(typeof($rootnamespaces$.CommonServices.SettingsService))]
namespace $rootnamespace$.CommonServices
{
    using Android;
    using Android.App;
    using Android.Content;
    using Android.Preferences;
    using Android.Provider;
    using Android.Support.Design.Widget;
    using Android.Support.V4.App;
    using Android.Telephony;    
    using Java.Security;
    using Newtonsoft.Json;
    using System;
    using System.IO;
    using System.IO.IsolatedStorage;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;
    using Xamarin.Forms;

    /// <summary>
    /// Settings service Android implementation.
    /// </summary>
    public class SettingsService : ISettingsService, ActivityCompat.IOnRequestPermissionsResultCallback
    {
        private const int PERMISSION_ID = 1;
        private const string StorageFile = "$rootnamespaces$.KeyValueStorage";

        private static IsolatedStorageFile File { get { return IsolatedStorageFile.GetUserStoreForApplication(); } }
        private static readonly object SaveLock = new object();
        private static ISharedPreferences SharedPreferences { get; set; }
        private static ISharedPreferencesEditor SharedPreferencesEditor { get; set; }

        private string[] permissionsPhone = { Manifest.Permission.ReadPhoneState };
        private KeyStore keyStore;
        private KeyStore.PasswordProtection protection;

        private Lazy<string> deviceId = new Lazy<string>(() =>
        {
            var tel = (TelephonyManager)Android.App.Application.Context.ApplicationContext.GetSystemService(Context.TelephonyService);
            return tel.DeviceId ?? Settings.Secure.GetString(Android.App.Application.Context.ApplicationContext.ContentResolver, Settings.Secure.AndroidId);
        });

        /// <summary>
        /// Default constructor
        /// </summary>
        public SettingsService()
        {
            if (ActivityCompat.CheckSelfPermission(Forms.Context, Manifest.Permission.ReadPhoneState) == (int)Android.Content.PM.Permission.Granted)
            {
                Init();
                InitSecure();
            }
            else
            {
                Init();
                RequestPhonePermissions();
            }
        }


        /// <summary>
        /// Gets the handle.
        /// </summary>
        /// <value>The handle.</value>
        public IntPtr Handle
        {
            get
            {
                return default(IntPtr);
            }
        }

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
                if (ActivityCompat.CheckSelfPermission(Forms.Context, Manifest.Permission.ReadPhoneState) == (int)global::Android.Content.PM.Permission.Granted)
                {
                    var entry = this.keyStore.GetEntry(key, this.protection) as KeyStore.SecretKeyEntry;
                    if (entry == null)
                        tcs.TrySetResult(default(T));
                    else
                    {
                        byte[] data = entry.SecretKey.GetEncoded();
                        var jsonValue = Encoding.UTF8.GetString(data);

                        tcs.TrySetResult(JsonConvert.DeserializeObject<T>(jsonValue));
                    }
                }
                else
                    tcs.TrySetResult(default(T));
            }
            else
            {
                string value = SharedPreferences.GetString(key, Convert.ToString(default(T)));
                if (!string.IsNullOrWhiteSpace(value))
                    tcs.TrySetResult(JsonConvert.DeserializeObject<T>(value));
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
        /// <returns><see cref="ISettingsService"/></returns>
        public Task<bool> SetSettingAsync<T>(string key, T value, bool isSecure = false)
        {
            TaskCompletionSource<bool> tcs = new TaskCompletionSource<bool>();
            if (isSecure)
            {
                if (ActivityCompat.CheckSelfPermission(Forms.Context, Manifest.Permission.ReadPhoneState) == (int)global::Android.Content.PM.Permission.Granted)
                {
                    string data = JsonConvert.SerializeObject(value);
                    var secureString = new ioTMM.KeyStore.StringKeyEntry(data);
                    var secureKeyEntry = new KeyStore.SecretKeyEntry(secureString);
                    keyStore.SetEntry(key, secureKeyEntry, protection);

                    lock (SaveLock)
                    {
                        using (var stream = new IsolatedStorageFileStream(StorageFile, FileMode.OpenOrCreate, FileAccess.Write))
                        {
                            this.keyStore.Store(stream, this.protection.GetPassword());
                        }
                    }
                    tcs.TrySetResult(true);
                }
            }
            else
            {
                SharedPreferencesEditor.PutString(key, JsonConvert.SerializeObject(value));
                SharedPreferencesEditor.Apply();
                SharedPreferencesEditor.Commit();
                tcs.TrySetResult(true);
            }

            return tcs.Task;
        }

        /// <summary>
        /// Method for request permissions callback.
        /// </summary>
        /// <param name="requestCode"></param>
        /// <param name="permissions"></param>
        /// <param name="grantResults"></param>
        public void OnRequestPermissionsResult(int requestCode, string[] permissions, [global::Android.Runtime.GeneratedEnum] global::Android.Content.PM.Permission[] grantResults)
        {
            if (grantResults.Any() && grantResults[0] == Android.Content.PM.Permission.Granted)
            {
                if (requestCode == PERMISSION_ID)
                {
                    InitSecure();
                }
            }
        }

        public void Dispose()
        {
        }

        private void Init()
        {
            SharedPreferences = PreferenceManager.GetDefaultSharedPreferences(Android.App.Application.Context);
            SharedPreferencesEditor = SharedPreferences.Edit();
        }

        private void InitSecure()
        {
            keyStore = KeyStore.GetInstance(KeyStore.DefaultType);
            protection = new KeyStore.PasswordProtection(deviceId.Value.ToCharArray());

            if (File.FileExists(StorageFile))
            {
                using (var stream = new IsolatedStorageFileStream(StorageFile, FileMode.Open, FileAccess.Read, File))
                {
                    try
                    {
                        keyStore.Load(stream, deviceId.Value.ToCharArray());
                    }
                    catch
                    {
                        keyStore.Load(null, deviceId.Value.ToCharArray());
                    }
                }
            }
            else
            {
                keyStore.Load(null, deviceId.Value.ToCharArray());
            }
        }

        private void RequestPhonePermissions()
        {
            if (ActivityCompat.ShouldShowRequestPermissionRationale((Forms.Context as Activity), Manifest.Permission.ReadPhoneState))
            {
                Snackbar.Make((Forms.Context as Activity).FindViewById((global::Android.Resource.Id.Content)), 
                               TranslateExtension.GetText("AndroidPhonePermissions"), Snackbar.LengthIndefinite)
                                .SetAction(TranslateExtension.GetText("OkUpperCase"), v =>
                                        {
                                            (Forms.Context as Activity).RequestPermissions(permissionsPhone, PERMISSION_ID);
                                        }).Show();
            }
            else
            {
                ActivityCompat.RequestPermissions((Forms.Context as Activity), permissionsPhone, PERMISSION_ID);
            }
        }
    }
}
